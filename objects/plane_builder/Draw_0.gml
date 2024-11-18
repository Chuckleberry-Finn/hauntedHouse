var y_scale = 0.9
var _x = 0;
var _y = 0;
var _z = -r_h*y_scale;
var _rotX = -90;
var _rotY = 0;
var _rotZ = 0;

if (draw == "east") {
    _x = room_width;
	_rotY = -90
	
} else if (draw == "west") {
    _y = room_height;
    _rotY = 90;

} else if (draw == "south") {
    _x = r_w;
    _y = room_height;
    _rotZ = 180;

} else if (draw == "the_floor") {
    _z = 0;
    _rotX = 0;
	p_color = c_white
	y_scale = 1;
}


var _texture = asset_get_index(p_texture);

surface_set_target(_surface); 
draw_clear_alpha(c_white, 0); 
draw_sprite_stretched_ext(_texture, 1, 0, 0, r_w, r_h*y_scale, p_color, 1);

surface_reset_target();

var mat = matrix_build(_x, _y, _z, _rotX, _rotY, _rotZ, 1, 1, 1);
matrix_set(matrix_world, mat);
draw_surface(_surface, 0, 0);

matrix_set(matrix_world, matrix_build_identity());


//draw_set_alpha(0.8)
//draw_surface(global.darkness_surface, 0, 0);
draw_surface_ext(global.darkness_surface, 0, 0, 1, 1, 0, c_dkgray, 1);  // Apply darkness map over the room