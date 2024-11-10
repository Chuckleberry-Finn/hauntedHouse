// Adjust the wall to lie parallel to the camera's view and floor.
// Rotate on x-axis to keep it aligned

if p_texture == "" { return };

var _x = r_w
var _y = 0
var _z = 0-186

var _texture = sprite_get_texture(asset_get_index(p_texture), -1)

var _rotX = 0
var _rotY = 0
var _rotZ = 0

if (draw == "east") {
	_x = room_width
	_y = r_w
	_rotZ = -90

} else if (draw == "west") {
	_x = 0
	_y = r_w
	_rotZ = 90
	
} else if (draw == "south") {
	_x = r_w
	_y = room_height
	_rotZ = 180


} else if (draw == "the_floor") {
    _x = r_w
	_y = r_h
	_z = 0
	_rotX = 90
}


var mat = matrix_build(_x, _y, _z, _rotX, _rotY, _rotZ, 1, 1, 0.77);

//The world matrix is what is used to transform drawing within "world" or "object" space.
matrix_set(matrix_world, mat);

// Draw the buffer
vertex_submit(vb_plane, pr_trianglelist, _texture);

//Resetting transforms can be done like this:
matrix_set(matrix_world, matrix_build_identity());