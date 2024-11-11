// Return early if no texture is assigned
if (p_texture == "") { 
    return; 
}

var _x = r_w;
var _y = 0;
var _z = -186;
var _rotX = 0;
var _rotY = 0;
var _rotZ = 0;

// Determine the position and rotation based on the plane's orientation
if (draw == "east") {
    _x = room_width;
    _y = r_w;
    _rotZ = -90;
} else if (draw == "west") {
    _x = 0;
    _y = r_w;
    _rotZ = 90;
} else if (draw == "south") {
    _x = r_w;
    _y = room_height;
    _rotZ = 180;
} else if (draw == "the_floor") {
    _x = r_w;
    _y = r_h;
    _z = 0;
    _rotX = 90;
}

// Ensure correct texture handling
var _texture = sprite_get_texture(asset_get_index(p_texture), -1);
texture_set_stage(0, _texture);  // Set the texture for the plane

// Set the transformation matrix for the plane
var mat = matrix_build(_x, _y, _z, _rotX, _rotY, _rotZ, 1, 1, 0.77);
matrix_set(matrix_world, mat);

// Draw the plane (vertex buffer)
vertex_submit(vb_plane, pr_trianglelist, _texture);

// Reset texture stage and shader to prevent affecting other objects
texture_set_stage(0, -1);

// Reset the world matrix after drawing the plane
matrix_set(matrix_world, matrix_build_identity());