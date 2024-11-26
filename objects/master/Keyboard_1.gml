if (keyboard_check_pressed(vk_escape)) {
    game_end();  // Exits the game
	return;
}

var player = global.player
if (player == noone) {
    return; // Exit if no player instance is found
}

// Get the camera angle (replace this with your actual camera angle variable)
var camera_angle = -90-global.view_xy; // For example, if the camera is rotated by 45 degrees

// Initialize variables
var target_angle = 0;
var rotation_speed = 5;
var step_speed = 10;
var is_moving = false;

// Check for arrow key inputs
var up_pressed = keyboard_check(ord("W"));
var down_pressed = keyboard_check(ord("S"));
var left_pressed = keyboard_check(ord("A"));
var right_pressed = keyboard_check(ord("D"));

// Count how many keys are pressed
var keys_pressed = up_pressed + down_pressed + left_pressed + right_pressed;

if (keys_pressed > 0) {
    is_moving = true;

    // If more than one key is pressed, adjust speed for diagonal movement
    if (keys_pressed > 1) {
        step_speed *= 0.707; // Reduce speed by √2 / 2 for diagonal movement
    }
}

// Determine the target angle based on the keys pressed
if (up_pressed && left_pressed) {
    target_angle = 315; // Up-Left
} else if (up_pressed && right_pressed) {
    target_angle = 225; // Up-Right
} else if (down_pressed && left_pressed) {
    target_angle = 45; // Down-Left
} else if (down_pressed && right_pressed) {
    target_angle = 135;  // Down-Right
} else if (up_pressed) {
    target_angle = 270; // Up
} else if (down_pressed) {
    target_angle = 90;  // Down
} else if (left_pressed) {
    target_angle = 0; // Left
} else if (right_pressed) {
    target_angle =180;   // Right
}

// Adjust target angle based on the camera's rotation
target_angle = (target_angle + camera_angle) mod 360;

// Move the player and adjust rotation if moving
if (is_moving) {
    // Calculate movement in the direction of target_angle
    var move_x = lengthdir_x(step_speed, target_angle);
    var move_y = lengthdir_y(step_speed, target_angle);

	with player { test_move_collide_script(x, y, move_x, move_y) };
	
    // Smoothly rotate player towards target_angle
    var angle_diff = angle_difference(player.image_angle+90, target_angle);
    
    // Rotate gradually towards the target angle
    if (abs(angle_diff) > rotation_speed) {
        player.image_angle += sign(angle_diff) * rotation_speed;
        player.image_angle = player.image_angle mod 360; // Ensure angle wraps around
    } else {
        player.image_angle = target_angle;
    }
	
	if (!audio_is_playing(sound_current)) {
	    // Random chance to decide whether a sound should play (e.g., 50% chance)
	    if (random(1) < 0.01) {
	        // Randomly select one sound from the pool of creaky sounds
	        var sound_pool = [snd_creak1, snd_creak2, snd_creak3, snd_creak4]; // Add your sounds to this array
	        var random_sound = sound_pool[irandom(array_length(sound_pool) - 1)];
        
	        // Play the selected sound
	        audio_play_sound(random_sound, 1, false);
        
	        // Track the current sound playing
	        sound_current = random_sound;
	    }
	}
}