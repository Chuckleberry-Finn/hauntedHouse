// Check if the middle mouse button (mouse wheel) is being held down
if (mouse_check_button(mb_middle)) {
    // If this is the first frame the button is pressed, initialize dragging
    if (!mouse_dragging) {
        mouse_dragging = true;
        last_mouse_x = display_mouse_get_x();
    } else {
        // Calculate the change in mouse position
        var current_mouse_x = display_mouse_get_x();
        var delta_x = current_mouse_x - last_mouse_x;
        
        global.view_xy += delta_x * 0.2; // Adjust the multiplier for sensitivity
        
        // Update the last mouse position if movement was significant
        last_mouse_x = current_mouse_x;
    }
} else {
    // Reset dragging state when the middle mouse button is released
    mouse_dragging = false;
}




// Update darkness map based on light sources
surface_set_target(global.darkness_surface);
draw_clear_alpha(c_black, 1);  // Reset to fully dark

// Loop through all light sources and adjust the darkness map
for (var i = 0; i < global.num_lights; i++) {
    var light = global.lights[i];  // Get each light source
    var light_x = light.x;
    var light_y = light.y;
    var light_range = light.range;
    var light_intensity = light.intensity;

    // Loop through the tiles in the range of the light
    for (var x_offset = -light_range; x_offset <= light_range; x_offset += grid_size) {
        for (var y_offset = -light_range; y_offset <= light_range; y_offset += grid_size) {
            var dist = point_distance(light_x, light_y, light_x + x_offset, light_y + y_offset);
            if (dist < light_range) {
                // Calculate light intensity at this tile (falloff based on distance)
                var alpha_value = clamp(1 - dist / light_range, 0, 1);  // Alpha value for darkness (higher = more dark)
                
                // Apply light intensity to the tile
                var tile_x = light_x + x_offset;
                var tile_y = light_y + y_offset;
                draw_set_alpha(alpha_value * light_intensity);  // Apply intensity as alpha for the light
                draw_rectangle(tile_x, tile_y, tile_x + grid_size, tile_y + grid_size, false);  // Update darkness map
            }
        }
    }
}

surface_reset_target();  // Reset the surface after drawing the light updates