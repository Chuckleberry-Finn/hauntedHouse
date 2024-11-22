if !surface_exists(global.darkness_surface) { global.darkness_surface = surface_create(room_width, room_height); }

surface_set_target(global.darkness_surface);

draw_clear_alpha(shadow_color, shadow_alpha);
gpu_set_depth(-5.2);

for (var i = 0; i < global.num_lights; i++) {
    var light = global.lights[i];
    var light_x = light.x;
    var light_y = light.y;
    var light_range = light.range;

	gpu_set_blendmode(bm_subtract);
	draw_set_alpha(1);
	draw_circle(light_x, light_y, light_range, false);
}

for (var i = 0; i < global.num_lights; i++) {
    var light = global.lights[i];
    var light_x = light.x;
    var light_y = light.y;
    var light_range = light.range;
    var light_intensity = light.intensity;
    var light_color = light.light_color;

    var light_alpha = lerp(0, light_intensity, shadow_alpha/0.8);

	gpu_set_blendmode(bm_add);
	draw_set_alpha(light_alpha / 255);
	draw_circle_color(light_x, light_y, light_range, light_color, light_color, false);
}

draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
gpu_set_depth(0);

surface_reset_target();