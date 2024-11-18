surface_set_target(global.darkness_surface);

// Clear the surface to the shadow color with some alpha for blending
draw_clear_alpha(shadow_color, 0.8);

// Set blending mode to additive, so the lights' colors add up
gpu_set_blendmode(bm_add);
gpu_set_depth(-5.2);

// Loop through each light and render its effect on the darkness
for (var i = 0; i < global.num_lights; i++) {
    var light = global.lights[i];
    var light_x = light.x;
    var light_y = light.y;
    var light_range = light.range;
    var light_intensity = light.intensity;
    var light_color = light.color;

    // The alpha value for the light, based on its intensity (scaled)
    var light_alpha = light_intensity;

    // Set the light's color and intensity (with the alpha of the light based on intensity)
    
	draw_set_alpha(light_alpha / 255);  // Light's alpha based on intensity
	draw_circle_color(light_x, light_y, light_range, light_color, light_color, false);  // Add light's color to the darkness
    
    /*
	for (var r = light_range; r > 0; r -= 4) {
        var alpha = light_alpha * (r / light_range);  // Gradually reduce the light's alpha based on radius
        draw_set_alpha(alpha / 255);  // Set alpha for the circle
		draw_circle_color(light_x, light_y, r, light_color, light_color, false);
    }
	*/
    
}

// Reset drawing settings
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
gpu_set_depth(0);

// Reset the surface target to draw to the screen
surface_reset_target();
