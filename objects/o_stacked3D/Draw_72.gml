var total_intensity = 0;
var light_intensity = 0;
var obj_left = x - sprite_width / 2;
var obj_right = x + sprite_width / 2;
var obj_top = y - sprite_height / 2;
var obj_bottom = y + sprite_height / 2;
	

for (var i = 0; i < array_length(global.lights); i++) {
    var light = global.lights[i]; // Get the current light source instance
    
    // Loop through the four corners of the object's bounding box
    var corners = [
        [obj_left, obj_top],   // Top-left corner
        [obj_right, obj_top],  // Top-right corner
        [obj_left, obj_bottom],// Bottom-left corner
        [obj_right, obj_bottom]// Bottom-right corner
    ];

    for (var j = 0; j < array_length(corners); j++) {
        var corner_x = corners[j][0];
        var corner_y = corners[j][1];
        var light_intensity = get_light_intensity_at_position(corner_x, corner_y);
        total_intensity += light_intensity;
    }
}

total_intensity /= 4;
obj_color = make_color_rgb(total_intensity * 255, total_intensity * 255, total_intensity * 255);

