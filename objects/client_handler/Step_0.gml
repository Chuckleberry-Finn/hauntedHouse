// Capture input and send to server
var input = {
    up: keyboard_check(ord("W")),
    down: keyboard_check(ord("S")),
    left: keyboard_check(ord("A")),
    right: keyboard_check(ord("D"))
};

network_send_to_server({
    player_id: global.local_player_id,
    input: input
});

// Update the local player's state from the server
if (network_receive()) {
    var buffer = network_buffer; // Replace with your actual buffer variable
    var p_id = buffer_read(buffer, buffer_u32);
    var p_x = buffer_read(buffer, buffer_f32);
    var p_y = buffer_read(buffer, buffer_f32);
    var room_id = buffer_read(buffer, buffer_u32);
    var facing = buffer_read(buffer, buffer_f32);

    if (player_id == global.local_player_id) {
        global.player.x = p_x;
        global.player.y = p_y;
        global.player.room_id = room_id;
        global.player.facing = facing;
    }
}