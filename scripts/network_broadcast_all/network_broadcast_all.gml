/// Broadcasts a message to all clients, optionally excluding a specific socket.
/// @param buffer The buffer to send
/// @param exclude_socket [Optional] The socket to exclude from the broadcast (defaults to no exclusion)
function network_broadcast_all(buffer, exclude_socket = -1) {
	for (var i = 0; i < array_length(global.players); i++) {
	    var client = global.players[i];
	    if (client._socket != exclude_socket && client._socket != global.server_socket) {
			show_debug_message("broadcasting to: " + string(client._socket))
	        network_send_packet(client._socket, buffer, buffer_tell(buffer));
	    }
    }
}