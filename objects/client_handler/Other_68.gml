if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"]; // Retrieve the buffer from async_load

    // Read the event type
    var e_type = buffer_read(buffer, buffer_u8);

    // Handle different event types
    switch (e_type) {
        case 1: // Example: Player position update
            var p_id = buffer_read(buffer, buffer_u32);
            var p_x = buffer_read(buffer, buffer_f32);
            var p_y = buffer_read(buffer, buffer_f32);
            var room_id = buffer_read(buffer, buffer_u32);
            var facing = buffer_read(buffer, buffer_f32);

            if (p_id == global.local_player_id) {
                global.player.x = p_x;
                global.player.y = p_y;
                global.player.room_id = room_id;
                global.player.facing = facing;
            }
            break;

        case 2: // Example: Lighting update
            var color = buffer_read(buffer, buffer_u32);
            var alpha = buffer_read(buffer, buffer_f32);

            master.shadow_color = color;
            master.shadow_alpha = alpha;
            break;

        default:
            show_debug_message("Unknown event type: " + string(e_type));
    }
}
