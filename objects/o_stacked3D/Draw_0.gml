depth = o_z


// In the Draw Event of o_stacked3D:
var total_intensity = 0;
var light_intensity = 0;

// Loop through each light source (assuming global.lights[] contains all light instances)
for (var i = 0; i < array_length(global.lights); i++) {
    var light = global.lights[i]; // Get the current light source instance
    
    // Get the bounding box of the object (o_stacked3D)
    var obj_left = x - sprite_width / 2;
    var obj_right = x + sprite_width / 2;
    var obj_top = y - sprite_height / 2;
    var obj_bottom = y + sprite_height / 2;
    
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

        // Calculate light intensity at this corner for the current light source
        var light_intensity = get_light_intensity_at_position(corner_x, corner_y, light.x, light.y, light.range);

        // Sum the intensities for each corner
        total_intensity += light_intensity;
    }
}

// Average the intensity across the corners (you can adjust this for different effect)
total_intensity /= 4;

// Adjust the object's color based on the average light intensity
var obj_color = make_color_rgb(total_intensity * 255, total_intensity * 255, total_intensity * 255);




for (var i = 0; i < image_number; i++) {
	var transform_matrix = matrix_build(
	    x, y, o_z - (i * 4),  // Stacked in the z-direction
	    0, 0, image_angle,            // No rotation
	    1, 1, 1             // Uniform scale
	);

	matrix_set(matrix_world, transform_matrix);

	draw_sprite_ext(sprite_index, i, 0, 0, 1, 1, 0, obj_color, 1);
}


matrix_set(matrix_world, matrix_build_identity());




