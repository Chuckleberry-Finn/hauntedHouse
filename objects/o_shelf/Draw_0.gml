var bottom = 0
var inner = 1
var body = 2
var top = 3

var sprites = [0]
for (var i = 0; i < tier; i++) { array_push(sprites, 0, 1, 2,2,2,2,2,2,2,0) }
array_push(sprites, 0, 3)

for (var i = 0; i < array_length(sprites); i++) {
	var layer_z = o_z - (i * 4);
    var transform_matrix = matrix_build(
        x, y, layer_z,  // Adjust only Z for vertical stacking, no X or Y changes
        0, 0, image_angle,  // No rotation
        1, 1, 1  // Uniform scale
    );

    var current_texture = sprite_get_texture(sprite_index, sprites[i]);
    texture_set_stage(0, current_texture); 
    matrix_set(matrix_world, transform_matrix);
    draw_sprite_ext(sprite_index, sprites[i], 0, 0, 1, 1, 0, c_white, 1);
	
	var _r = obj_color[0]
	var _g = obj_color[1]
	var _b = obj_color[2]
	var _color = make_color_rgb(_r,_g,_b)
	var _a = obj_color[3]

	draw_sprite_ext(sprite_index, sprites[i], 0, 0, 1, 1, 0, _color, _a);
    
}
matrix_set(matrix_world, matrix_build_identity());