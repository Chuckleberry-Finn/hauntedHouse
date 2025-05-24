if (async_load[? "type"] == network_type_connect) {
    var client_socket = async_load[? "socket"];

    var new_player = {
        _socket: client_socket,
        _x: room_width / 2,
        _y: room_height / 2,
        _room_id: 0,
        _facing: 0
    };
    array_push(global.players, new_player);

	// Send House Map to the new client
    var house_map_json = json_stringify(global.house_map);
    var response_buffer = buffer_create(256, buffer_grow, 1);
    buffer_write(response_buffer, buffer_u8, 2);
    buffer_write(response_buffer, buffer_string, house_map_json);
	buffer_write(response_buffer, buffer_s32, client_socket);
	
	var players_json = json_stringify(global.players);
	buffer_write(response_buffer, buffer_string, players_json);
	
    network_send_packet(client_socket, response_buffer, buffer_tell(response_buffer));
    buffer_delete(response_buffer);

	show_debug_message("Server: Client connected on socket " + string(client_socket));
}


if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"];
    var client_socket = async_load[? "socket"];
    var e_type = buffer_read(buffer, buffer_u8);  // Read event type
	
	show_debug_message("player update recieved. " + string(e_type))
	
    switch (e_type) {
		
		case 1:  // Player Position Update
		
			show_debug_message("player update recieved.")
		
		    var p_socket = buffer_read(buffer, buffer_s32);
		    var p_x = buffer_read(buffer, buffer_f32);
		    var p_y = buffer_read(buffer, buffer_f32);
		    var room_id = buffer_read(buffer, buffer_u32);
		    var facing = buffer_read(buffer, buffer_f32);

		    // Update server-side player data
		    var player_found = false;
		    for (var i = 0; i < array_length(global.players); i++) {
		        var player = global.players[i];
				//show_debug_message("player._socket: " + string(player._socket))
		        if (player._socket == p_socket) {
		            player._x = p_x;
		            player._y = p_y;
		            player._room_id = room_id;
		            player._facing = facing;
		            player_found = player;
		            break;
		        }
		    }

		    if (player_found) {
		        // Broadcast the updated position to all clients
		        var broadcast_buffer = buffer_create(256, buffer_grow, 1);
		        buffer_write(broadcast_buffer, buffer_u8, 1);  // Event Type 1: Player Position Update
		        buffer_write(broadcast_buffer, buffer_s32, p_socket);
		        buffer_write(broadcast_buffer, buffer_f32, p_x);
		        buffer_write(broadcast_buffer, buffer_f32, p_y);
		        buffer_write(broadcast_buffer, buffer_u32, room_id);
		        buffer_write(broadcast_buffer, buffer_f32, facing);
				
				update_player_instance(player_found)
				
		        network_broadcast_all(broadcast_buffer); 
		        buffer_delete(broadcast_buffer);
				
		        show_debug_message("Server: Broadcasted player movement for socket " + string(client_socket));
		    }
		    break;
       
		
        case 7:  // Room Objects Update from Client
            var obj_json = buffer_read(buffer, buffer_string);
            var room_update = json_parse(obj_json);

            // Direct Room Update Using floor_id
            var floor_id = room_update.floor_id;
            var room_id = room_update.room_id;
            var _room = global.house_map[floor_id][room_id];
			
            _room.objects = room_update.objects;
            _room.generated = true;  // Mark the room as generated

            // Broadcast the update to all connected clients
            var broadcast_buffer = buffer_create(256, buffer_grow, 1);
            buffer_write(broadcast_buffer, buffer_u8, 7);  // Event Type: Room Objects Update
            buffer_write(broadcast_buffer, buffer_string, obj_json);
            network_broadcast_all(broadcast_buffer);
            buffer_delete(broadcast_buffer);

            show_debug_message("Server: Broadcasted updated room objects.");
            break;
    }
}


if (async_load[? "type"] == network_type_disconnect) {
    var client_socket = async_load[? "socket"];
    
    for (var i = array_length(global.players) - 1; i >= 0; i--) {
        if (global.players[i]._socket == client_socket) {
            array_delete(global.players, i, 1);

            var buffer = buffer_create(256, buffer_grow, 1);
            buffer_write(buffer, buffer_u8, 8);  // Event Type: Player Disconnect
            buffer_write(buffer, buffer_s32, client_socket);
            network_broadcast_all(buffer);
            buffer_delete(buffer);
            break;
        }
    }
	
	for (var i = array_length(global.other_players) - 1; i >= 0; i--) {
	    if (global.other_players[i].inst_socket == client_socket) {
	        instance_destroy(global.other_players[i]);
	        array_delete(global.other_players, i, 1);
	        break;
	    }
	}
	
	 show_debug_message("Server: Client " + string(client_socket) + " disconnected.");
}