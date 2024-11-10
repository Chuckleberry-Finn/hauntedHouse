var transform_matrix = matrix_build(
    x, y, o_z,                 // Position the billboard with a negative z_offset
    -90, 90 - global.view_xy, 0,    // Rotate to face the camera
    1, 1, 1
);

depth = o_z

gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);

matrix_set(matrix_world, transform_matrix);

draw_sprite_ext(sprite_index, image_index, 0, -90, 1, 1, direction, c_white, 1);

matrix_set(matrix_world, matrix_build_identity());

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);