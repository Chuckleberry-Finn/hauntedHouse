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




