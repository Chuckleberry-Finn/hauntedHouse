/// @desc Sends a buffer to all connected clients
/// @param buffer The buffer to send
function network_broadcast_all(buffer) {
    for (var i = 0; i < array_length(global.players); i++) {
        var client = global.players[i];
        if (client.socket != undefined) {
            network_send_raw(client.socket, buffer, buffer_tell(buffer));
        }
    }
}