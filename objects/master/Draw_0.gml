surface_set_target(global.darkness_surface)
gpu_set_depth(-5.1);
draw_clear_alpha(shadow_color, 1)

gpu_set_blendmode(bm_subtract);
gpu_set_depth(-5.2);
draw_set_color(c_black); 
	
for (var i = 0; i < global.num_lights; i++) {
    var light = global.lights[i];
    var light_x = light.x;
    var light_y = light.y;
    var light_range = light.range;
    var light_intensity = light.intensity;

    var light_alpha = light_intensity;

    //draw_set_alpha(light_alpha/255);  // Set alpha based on light intensity (scaled from 0 to 1)
	draw_circle_color(light_x, light_y, light_range, c_gray, c_white, false);
	
	// Draw a circle with a gradient-like effect for the light intensity
	/*for (var r = light_range; r > 0; r -= 4) {
	    var alpha = light_alpha * (r / light_range);
	    draw_set_alpha(alpha / 255);  // Gradually reduce alpha based on the radius
	    draw_circle(light_x, light_y, r, false);
	}*/
}
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
gpu_set_depth(0);
surface_reset_target();