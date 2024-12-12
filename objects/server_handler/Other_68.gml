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
    } else {
        show_debug_message("Server: Connection failed.");
    }
}

if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"];
    var client_socket = async_load[? "socket"];
    var e_type = buffer_read(buffer, buffer_u8);

	show_debug_message("e_type:" + string(e_type));

    // Handle Different Event Types
    switch (e_type) {
        case 1:  // House Map Request
            show_debug_message("Server: Received house map request from client " + string(client_socket));

            // Send House Map Back
            var house_map_json = json_stringify(global.house_map);
            var response_buffer = buffer_create(256, buffer_grow, 1);
            buffer_write(response_buffer, buffer_u8, 2);  // Event Type 2: House Map Data
            buffer_write(response_buffer, buffer_string, house_map_json);
            network_send_raw(client_socket, response_buffer, buffer_tell(response_buffer));
            buffer_delete(response_buffer);

            show_debug_message("Server: Sent house map to client " + string(client_socket));
            break;

        default:
            show_debug_message("Server: Unknown event type " + string(e_type) + " from client " + string(client_socket));
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