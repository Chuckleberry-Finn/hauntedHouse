event_inherited()

if (is_array(global.other_players)) {
    for (var i = 0; i < array_length(global.other_players); i++) {
        if (global.other_players[i] == id) {
            // Draw the index number above the object
            draw_set_color(c_white);  // Set text color
            draw_text(x + sprite_width/2, y - sprite_height / 2 - 10, string(inst_socket));
            break;  // Stop after finding the first match
        }
    }
}

if id == global.player { draw_circle(x, y, sprite_width/2, true) }

