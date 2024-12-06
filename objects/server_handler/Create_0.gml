global.players = [];  // Track all connected players
global.house_map = global.houseHandler.generate_house_map(global.max_rooms, global.num_floors); // Generate the house

/// @param buffer The buffer to send
function network_broadcast_all(buffer) {
    for (var i = 0; i < array_length(global.players); i++) {
        var client = global.players[i];
        network_send(client.socket, buffer, buffer_tell(buffer));
    }
}