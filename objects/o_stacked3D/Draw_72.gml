var total_red_intensity = 0;
var total_green_intensity = 0;
var total_blue_intensity = 0;
var total_intensity = 0;

// Accumulate the intensity and color for each light source in range
for (var i = 0; i < array_length(global.lights); i++) {
    var light = global.lights[i]; 
    var distance = point_distance(x, y, light.x, light.y);
    
    if (distance <= light.range) {
        var light_intensity = light.intensity / 255;  // Normalize intensity to range 0-1 (based on alpha)
        
        var light_color_r = color_get_red(light.light_color);
        var light_color_g = color_get_green(light.light_color);
        var light_color_b = color_get_blue(light.light_color);
        
        // Additive blending: Accumulate the intensity and the color
        total_red_intensity += light_intensity * light_color_r;
        total_green_intensity += light_intensity * light_color_g;
        total_blue_intensity += light_intensity * light_color_b;
        
        total_intensity += light_intensity;  // Accumulate the overall intensity
    }
}

// Get the shadow color and adjust by shadow_alpha
var _r = color_get_red(global.shadow_color);
var _g = color_get_green(global.shadow_color);
var _b = color_get_blue(global.shadow_color);

// Adjust shadow color based on shadow_alpha (simulating lightning effect)
var alpha = lerp(1, global.shadow_alpha, global.shadow_alpha / 0.8);  // Normalize shadow_alpha to [0, 1]
var shadow_r = _r * alpha;
var shadow_g = _g * alpha;
var shadow_b = _b * alpha;

// Dim the light intensity based on shadow_alpha (so the light dims as shadow fades)
var dimmed_red_intensity = total_red_intensity * alpha;
var dimmed_green_intensity = total_green_intensity * alpha;
var dimmed_blue_intensity = total_blue_intensity * alpha;

// Combine the shadow color with the dimmed light intensity for final object color
var final_red = lerp(shadow_r, dimmed_red_intensity, global.shadow_alpha / 0.8);
var final_green = lerp(shadow_g, dimmed_green_intensity, global.shadow_alpha / 0.8);
var final_blue = lerp(shadow_b, dimmed_blue_intensity, global.shadow_alpha / 0.8);

// Set the final object color based on the shadow color and light intensity
obj_color = [final_red, final_green, final_blue, global.shadow_alpha]