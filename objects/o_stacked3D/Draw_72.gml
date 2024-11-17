// Initialize total_intensity for the object (starting from 0)
var total_intensity = 0;
var obj_left = x - sprite_width / 2;
var obj_right = x + sprite_width / 2;
var obj_top = y - sprite_height / 2;
var obj_bottom = y + sprite_height / 2;

// Loop through all light sources
for (var i = 0; i < array_length(global.lights); i++) {
    var light = global.lights[i]; // Get the current light source instance
    
    // Loop through the four corners of the object's bounding box
    var corners = [
        [obj_left, obj_top],   // Top-left corner
        [obj_right, obj_top],  // Top-right corner
        [obj_left, obj_bottom],// Bottom-left corner
        [obj_right, obj_bottom]// Bottom-right corner
    ];

    // Loop through each corner and accumulate light intensity
    for (var j = 0; j < array_length(corners); j++) {
        var corner_x = corners[j][0];
        var corner_y = corners[j][1];
        
        // Calculate light intensity at each corner using the existing function
        var light_intensity = get_partial_light_intensity(corner_x, corner_y, light.x, light.y, light.range, light.intensity);
        
        // Add the light intensity to the total intensity (for all corners)
        total_intensity += light_intensity;
    }
}


// Average out the intensity (since we're using 4 corners, we divide by 4)
total_intensity /= 4;

// Map the total intensity to the range 0-255
total_intensity = total_intensity * 255;  // Now intensity is on a scale of 0 to 255

// Ensure the intensity stays within the bounds [0, 255]
total_intensity = clamp(total_intensity, 0, 255);

// Normalize intensity to the range 0-1 for blending (0 = shadow, 1 = white)
total_intensity /= 255;

// Apply the light intensity to the object’s color (blend between shadow_color and white)
var _r = color_get_red(master.shadow_color);
var _g = color_get_green(master.shadow_color);
var _b = color_get_blue(master.shadow_color);

// Interpolate between the shadow color (black) and white (1,1,1)
var red_component = lerp(_r, 255, total_intensity);
var green_component = lerp(_g, 255, total_intensity);
var blue_component = lerp(_b, 255, total_intensity);

// Create the final color
obj_color = make_color_rgb(red_component, green_component, blue_component);
