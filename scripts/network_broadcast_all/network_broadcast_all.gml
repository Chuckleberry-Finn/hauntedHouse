/// Broadcasts a message to all clients, optionally excluding a specific socket.
/// @param buffer The buffer to send
/// @param exclude_socket [Optional] The socket to exclude from the broadcast (defaults to no exclusion)
function network_broadcast_all(buffer, exclude_socket = -1) {
    for (var i = 0; i < array_length(global.players); i++) {
        var client = global.players[i];

        // Skip the excluded socket and the server itself
        if (client.socket != exclude_socket && client.socket != global.server_socket) {
            network_send_packet(client.socket, buffer, buffer_tell(buffer));
        }
    }
}