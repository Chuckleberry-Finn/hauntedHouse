/// @desc Sends a buffer to all connected clients
/// @param buffer The buffer to send
function network_broadcast_all(buffer) {
    if (!is_array(global.players)) {
        show_debug_message("Error: No players to broadcast to.");
        return;
    }

    for (var i = 0; i < array_length(global.players); i++) {
        var client = global.players[i];

        // Ensure the client has a valid socket
        if (client != undefined && client.socket != undefined && client.socket != -1) {
            var result = network_send_raw(client.socket, buffer, buffer_tell(buffer));

            // Log failed sends
            if (result < 0) {
                show_debug_message("Error: Failed to send data to client " + string(client.socket));
			} else {
				show_debug_message("broadcasting: sending data to client " + string(client.socket));
            }
        }
    }
}