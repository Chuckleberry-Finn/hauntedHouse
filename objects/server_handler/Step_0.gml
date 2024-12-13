/*
// Process player inputs
for (var i = 0; i < array_length(global.players); i++) {
    var player = global.players[i];

    // Handle input (received from client)
    var input = player.input;  // Example: {up, down, left, right, facing}

    if (input != undefined) {
        // Apply movement
        var move_x = 0;
        var move_y = 0;

        if (input.up) move_y -= player.step_speed;
        if (input.down) move_y += player.step_speed;
        if (input.left) move_x -= player.step_speed;
        if (input.right) move_x += player.step_speed;

        test_move_collide_script(player.x, player.y, move_x, move_y);
    }

    // Create the buffer for sending player position
    var buffer = buffer_create(256, buffer_grow, 1);
    buffer_write(buffer, buffer_u8, 1); // Event type: Player position update
    buffer_write(buffer, buffer_u32, player.id);
    buffer_write(buffer, buffer_f32, player.x);
    buffer_write(buffer, buffer_f32, player.y);
    buffer_write(buffer, buffer_u32, player.room_id);
    buffer_write(buffer, buffer_f32, player.facing);

    // Send the buffer to all connected clients
    for (var j = 0; j < array_length(global.players); j++) {
        var client = global.players[j];
        network_send(client.socket, buffer, buffer_tell(buffer));
    }

    buffer_delete(buffer);
}
*/