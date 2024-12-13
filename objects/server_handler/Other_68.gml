/// Server Handler Asynchronous Networking Event

if (async_load[? "type"] == network_type_connect) {
    var client_socket = async_load[? "socket"];

    if (client_socket != -1) {
        show_debug_message("Server: Client connected on socket " + string(client_socket));

        // Add client to player list
        var new_client = {
            socket: client_socket
        };
        array_push(global.players, new_client);
		
		// Send House Map
        var house_map_json = json_stringify(global.house_map);
        var response_buffer = buffer_create(256, buffer_grow, 1);
        buffer_write(response_buffer, buffer_u8, 2);  // Event Type 2: House Map Data
        buffer_write(response_buffer, buffer_string, house_map_json);
        network_send_packet(client_socket, response_buffer, buffer_tell(response_buffer));
        buffer_delete(response_buffer);

        show_debug_message("Server: Sent house map to client " + string(client_socket));
		
    } else {
        show_debug_message("Server: Connection failed.");
    }
}


if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"];
    var client_socket = async_load[? "socket"];
    var e_type = buffer_read(buffer, buffer_u8);  // Read event type

    switch (e_type) {
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
    show_debug_message("Server: Client " + string(client_socket) + " disconnected.");

    // Remove the client from the players list
    for (var i = 0; i < array_length(global.players); i++) {
        if (global.players[i].socket == client_socket) {
            array_delete(global.players, i, 1);
            break;
        }
    }
}