// unique draw for this object cause fuck stacking
depth = o_z

var stack_rep = 13; // Number of times each sprite is drawn (for the "staircase" effect)
var step_height = 2; // Controls the height of each step (adjust for spacing between sprites)

var z_offset = 0

for (var i = 0; i < image_number; i++) {
    for (var ii = 0; ii < stack_rep; ii++) {
        // Incremental vertical offset for each sprite, controlled by ii and step_height
        z_offset += step_height; // Only adjust the Z-position for vertical stacking

        // Build a transformation matrix with the Z offset
        var transform_matrix = matrix_build(
            x, y, o_z - z_offset,  // Adjust only Z for vertical stacking, no X or Y changes
            0, 0, image_angle,  // No rotation
            1, 1, 1  // Uniform scale
        );

        // Set the world transformation matrix
        matrix_set(matrix_world, transform_matrix);

        // Draw the sprite at the correct position (no changes to x, y, rotation)
        draw_sprite_ext(sprite_index, i, 0, 0, 1, 1, 0, c_white, 1);
    }
}

// Reset the transformation matrix to identity after drawing
matrix_set(matrix_world, matrix_build_identity());