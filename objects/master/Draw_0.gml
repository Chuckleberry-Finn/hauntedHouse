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