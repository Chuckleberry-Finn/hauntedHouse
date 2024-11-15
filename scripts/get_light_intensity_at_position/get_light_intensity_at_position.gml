// Smoothstep function for smooth gradient
function smoothstep(edge0, edge1, x) {
    var t = clamp((x - edge0) / (edge1 - edge0), 0, 1);
    return t * t * (3 - 2 * t);  // This creates a smooth curve
}

// Updated get_light_intensity_at_position function
function get_light_intensity_at_position(_x, _y) {
    var total_intensity = 0;

    // Loop through all light sources and calculate intensity for the tile
    for (var i = 0; i < global.num_lights; i++) {
        var light = global.lights[i];
        var dist = point_distance(_x, _y, light.x, light.y);

        // Ensure light only affects the area within the light's range
        if (dist < light.range) {
            // Apply smoothfalloff and restrict intensity to zero beyond the light's range
            var intensity = light.intensity * (1 - smoothstep(light.range * 0.9, light.range, dist));  // Smooth transition up to the edge
            total_intensity += intensity;
        }
    }

    // Ensure that total intensity is clamped between 0 and 1
    return clamp(total_intensity, 0, 1);
}