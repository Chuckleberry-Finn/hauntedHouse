function get_partial_light_intensity(_obj_x, _obj_y, _light_x, _light_y, _light_range, _light_intensity) {

    var distance = point_distance(_obj_x, _obj_y, _light_x, _light_y);
    if (distance >= _light_range) { return 0; }

    var falloff_intensity = 1 - (distance / _light_range);  
    var final_intensity = _light_intensity * falloff_intensity;
    final_intensity = final_intensity * 255;  
    return final_intensity;
	
}