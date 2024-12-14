if (async_load[? "type"] == network_type_connect) {
    var client_socket = async_load[? "socket"];

    if (client_socket != -1) {
        show_debug_message("Server: Client connected on socket " + string(client_socket));

        // Create and add a new client to the player list
        var new_player = {
            socket: client_socket,
            x: room_width / 2,
            y: room_height / 2,
            room_id: 0,
            facing: 0
        };
        array_push(global.players, new_player);

        // Send House Map to the new client
        var house_map_json = json_stringify(global.house_map);
        var response_buffer = buffer_create(256, buffer_grow, 1);
        buffer_write(response_buffer, buffer_u8, 2);  // Event Type 2: House Map Data
        buffer_write(response_buffer, buffer_string, house_map_json);
        network_send_packet(client_socket, response_buffer, buffer_tell(response_buffer));
        buffer_delete(response_buffer);
        show_debug_message("Server: Sent house map to client " + string(client_socket));

        // Notify all clients (including the new one) about the new player
        var broadcast_buffer = buffer_create(256, buffer_grow, 1);
        buffer_write(broadcast_buffer, buffer_u8, 1);  // Event Type 1: New Player
        buffer_write(broadcast_buffer, buffer_u32, client_socket);  // Player's socket ID
        buffer_write(broadcast_buffer, buffer_f32, new_player.x);
        buffer_write(broadcast_buffer, buffer_f32, new_player.y);
        buffer_write(broadcast_buffer, buffer_u32, new_player.room_id);
        buffer_write(broadcast_buffer, buffer_f32, new_player.facing);

        network_broadcast_all(broadcast_buffer);
        buffer_delete(broadcast_buffer);
        show_debug_message("Server: Broadcasted new player connection.");
    } else {
        show_debug_message("Server: Connection failed.");
    }
}


if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"];
    var client_socket = async_load[? "socket"];
    var e_type = buffer_read(buffer, buffer_u8);  // Read event type

    switch (e_type) {
		
		case 1:
            var p_socket = buffer_read(buffer, buffer_u32);
            var p_x = buffer_read(buffer, buffer_f32);
            var p_y = buffer_read(buffer, buffer_f32);
            var room_id = buffer_read(buffer, buffer_u32);
            var facing = buffer_read(buffer, buffer_f32);

            // Update player data on server
            var player_found = false;
            for (var i = 0; i < array_length(global.players); i++) {
                if (global.players[i].socket == p_socket) {
                    global.players[i].x = p_x;
                    global.players[i].y = p_y;
                    global.players[i].room_id = room_id;
                    global.players[i].facing = facing;
                    player_found = true;
                    break;
                }
            }

            // Broadcast the updated position to all clients
            if (player_found) {
                var broadcast_buffer = buffer_create(256, buffer_grow, 1);
                buffer_write(broadcast_buffer, buffer_u8, 1);  // Event Type: Player Position Update
                buffer_write(broadcast_buffer, buffer_u32, p_socket);
                buffer_write(broadcast_buffer, buffer_f32, p_x);
                buffer_write(broadcast_buffer, buffer_f32, p_y);
                buffer_write(broadcast_buffer, buffer_u32, room_id);
                buffer_write(broadcast_buffer, buffer_f32, facing);

                // Broadcast to all except the sending client
                network_broadcast_all(broadcast_buffer, p_socket);
                buffer_delete(broadcast_buffer);

                show_debug_message("Server: Broadcasted player movement for socket " + string(p_socket));
            } else {
                show_debug_message("Server: Player not found for socket " + string(p_socket));
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
    
    // Remove the player from the server's player list
    for (var i = array_length(global.players) - 1; i >= 0; i--) {
        if (global.players[i].socket == client_socket) {
            array_delete(global.players, i, 1);

            // Notify all other clients about the disconnect
            var buffer = buffer_create(256, buffer_grow, 1);
            buffer_write(buffer, buffer_u8, 8);  // Event Type: Player Disconnect
            buffer_write(buffer, buffer_u32, client_socket);
            network_broadcast_all(buffer);
            buffer_delete(buffer);

            show_debug_message("Server: Removed disconnected client " + string(client_socket));
            break;
        }
    }
}