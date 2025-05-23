// Helper Function: Checks if the player is facing within a certain range of a target angle
/// @param target_angle The direction the player should be facing (0, 90, 180, 270)
/// @param tolerance The acceptable range around the target angle (default 40 degrees)
function is_facing_direction(target_angle) {
    var tolerance = 45;
    var player_angle = global.player.image_angle + 90;
    
    // Normalize angles to be within 0-360 range
    player_angle = (player_angle + 360) % 360;
    target_angle = (target_angle + 360) % 360;

    // Calculate the angle difference, ensuring we handle circular angles correctly
    var angle_diff = abs(angle_difference(player_angle, target_angle));

    // If the difference is greater than 180 degrees, we are on the other side of the circle
    if (angle_diff > 180) {
        angle_diff = 360 - angle_diff;
    }

    // Return true if the angle difference is within the tolerance
    return (angle_diff <= tolerance);
}


//GOOD
function test_move_collide_script(_x, _y, move_x, move_y) {
	
	// Ensure the current room is defined and has the correct structure
    if (!variable_global_exists("current_room") || !is_struct(global.current_room)) {
        show_debug_message("Error: Current room is not set or has incorrect type.");
        return;
    }

    // Ensure connected room IDs exist and are valid
    if (!is_array(global.current_room.connected_room_ids)) {
        show_debug_message("Error: Connected room IDs are not set.");
        return;
    }
	
    // Calculate the new potential position based on movement
    var new_x = _x + move_x;
    var new_y = _y + move_y;

    // Get the player's sprite dimensions
    var pH = sprite_height / 2;
    var pW = sprite_width / 2;

    // Define the room boundaries with padding to account for the sprite size
    var room_left = 0 + pW;
    var room_right = room_width - pW;
    var room_top = 0 + pH;
    var room_bottom = room_height - pH;

    // Variables for collision detection
    var collision_margin = 0.33;
    var instance = noone;

    // Step 1: Check for collisions with circular objects (e.g., o_stacked3D)
    instance = instance_place(new_x, new_y, o_stacked3D);

    // Handle collision with circular objects
    if (instance != noone and instance.solid) {
        var obj_x = instance.x;
        var obj_y = instance.y;
        var obj_radius = instance.sprite_width / 2;
        var to_player_x = x - obj_x;
        var to_player_y = y - obj_y;
        var distance = point_distance(x, y, obj_x, obj_y);

        if (distance < obj_radius + collision_margin) {
            var normal_x = to_player_x / max(distance, 0.01);
            var normal_y = to_player_y / max(distance, 0.01);
            x = obj_x + normal_x * (obj_radius + collision_margin);
            y = obj_y + normal_y * (obj_radius + collision_margin);

            distance = point_distance(x, y, obj_x, obj_y);
            normal_x = to_player_x / max(distance, 0.01);
            normal_y = to_player_y / max(distance, 0.01);

            var dot_prod = move_x * normal_x + move_y * normal_y;
            move_x -= dot_prod * normal_x;
            move_y -= dot_prod * normal_y;
        }
    }


    // Step 2: Handle door collisions and room transitions with angle range check
    if (global.current_room != undefined && is_array(global.current_room.connected_room_ids)) {
        var center_threshold = 64;

        // Check for the north wall (top)
        if (new_y < room_top) {
            if (abs(new_x - room_width / 2) < center_threshold && is_facing_direction(270)) {
                if (global.current_room.connected_room_ids[0] != undefined) {
                    show_debug_message("Going through the north door");
                    global.houseHandler.enter_room("north", global.current_room.connected_room_ids[0]);
                    return;
                }
            }
            y = room_top;
            move_y = 0;
        }

        // Check for the south wall (bottom)
        if (new_y > room_bottom) {
            if (abs(new_x - room_width / 2) < center_threshold && is_facing_direction(90)) {
                if (global.current_room.connected_room_ids[2] != undefined) {
                    show_debug_message("Going through the south door");
                    global.houseHandler.enter_room("south", global.current_room.connected_room_ids[2]);
                    return;
                }
            }
            y = room_bottom;
            move_y = 0;
        }

        // Check for the east wall (right)
        if (new_x > room_right) {
            if (abs(new_y - room_height / 2) < center_threshold && is_facing_direction(180)) {
                if (global.current_room.connected_room_ids[1] != undefined) {
                    show_debug_message("Going through the east door");
                    global.houseHandler.enter_room("east", global.current_room.connected_room_ids[1]);
                    return;
                }
            }
            x = room_right;
            move_x = 0;
        }

        // Check for the west wall (left)
        if (new_x < room_left) {
            if (abs(new_y - room_height / 2) < center_threshold && is_facing_direction(0.5)) {
                if (global.current_room.connected_room_ids[3] != undefined) {
                    show_debug_message("Going through the west door");
                    global.houseHandler.enter_room("west", global.current_room.connected_room_ids[3]);
                    return;
                }
            }
            x = room_left;
            move_x = 0;
        }
    } else {
        show_debug_message("Error: current_room or connected_room_ids is not set properly.");
    }

    // Step 3: Apply the final movement after handling collisions
    x += move_x;
    y += move_y;
}
