var total_red_intensity = 0;
var total_green_intensity = 0;
var total_blue_intensity = 0;

for (var i = 0; i < array_length(global.lights); i++) {
    var light = global.lights[i]; 
    var distance = point_distance(x, y, light.x, light.y);
    
    if (distance <= light.range) {
        var light_intensity = light.intensity;
        
        var light_color_r = color_get_red(light.color);
        var light_color_g = color_get_green(light.color);
        var light_color_b = color_get_blue(light.color);
        
        total_red_intensity += light_intensity * light_color_r;
        total_green_intensity += light_intensity * light_color_g;
        total_blue_intensity += light_intensity * light_color_b;
    }
}

var _r = color_get_red(master.shadow_color);
var _g = color_get_green(master.shadow_color);
var _b = color_get_blue(master.shadow_color);

var alpha = lerp(1, 0.8, master.shadow_alpha)
var shadow_r = _r * alpha;
var shadow_g = _g * alpha;
var shadow_b = _b * alpha;

var red_component = lerp(shadow_r, total_red_intensity, total_red_intensity);
var green_component = lerp(shadow_g, total_green_intensity, total_green_intensity);
var blue_component = lerp(shadow_b, total_blue_intensity, total_blue_intensity);

obj_color = make_color_rgb(red_component, green_component, blue_component);
