function get_partial_light_intensity(_obj_x, _obj_y, _obj_width, _obj_height, _light_x, _light_y, _light_range) {
    // Calculate the distance from the object center to the light source
    var distance = point_distance(_obj_x, _obj_y, _light_x, _light_y);

	// Assuming the object is a sprite, we can use the bounding box:
	var obj_left = x - sprite_width / 2;
	var obj_right = x + sprite_width / 2;
	var obj_top = y - sprite_height / 2;
	var obj_bottom = y + sprite_height / 2;

    // If the object is within the light's range, calculate how much is affected by light
    if (distance < _light_range) {
        var light_intensity = 1 - (distance / _light_range);  // Light intensity decreases with distance

        // Now, we need to check how much of the object is within the light
        // For simplicity, let's assume we have a rectangular object (this could be more complex for irregular shapes)
        var intersection_area = 0;

        // Calculate the overlap area between the object and the light range
        var obj_rect = [obj_left, obj_top, obj_right, obj_bottom]; // Rectangle of the object
        var light_rect = [ _light_x - _light_range, _light_y - _light_range, _light_x + _light_range, _light_y + _light_range ]; // Rectangle of the light range
        
        // Check if the object is inside the light's area (or partially)
        if (obj_rect[0] < light_rect[2] && obj_rect[2] > light_rect[0] && obj_rect[1] < light_rect[3] && obj_rect[3] > light_rect[1]) {
            // Calculate overlap (this is a simplified version; you might want to calculate the exact intersection area)
            intersection_area = min(_obj_width * _obj_height, _light_range * _light_range);  // Assume full area overlaps (simplified)
        }

        // Calculate the proportion of the object under the light and adjust the intensity
        var area_under_light = intersection_area / (_obj_width * _obj_height);
        return light_intensity * area_under_light;
    }

    return 0;  // No light affects this object if it's outside the range
}