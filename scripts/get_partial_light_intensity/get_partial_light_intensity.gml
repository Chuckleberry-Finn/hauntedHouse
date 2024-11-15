function get_partial_light_intensity(_obj_x, _obj_y, _light_x, _light_y, _light_range, _light_intensity) {
    // Calculate the distance from the object center to the light source
    var distance = point_distance(_obj_x, _obj_y, _light_x, _light_y);
    
    // If the object is outside the light's range, return 0 (no light)
    if (distance >= _light_range) {
        return 0;
    }

    // Light intensity decreases with distance (falloff)
    var falloff_intensity = 1 - (distance / _light_range);  // Linear falloff, closer objects get more intensity

    // Now, factor in the intensity from the argument (_light_intensity)
    var final_intensity = _light_intensity * falloff_intensity;  // Apply the overall light intensity

    // Scale the final intensity to the range of 0 to 255
    final_intensity = final_intensity * 255;  // Convert to 0-255 scale

    // Return the final intensity (it will be in the range of 0 to 255 now)
    return final_intensity;
}