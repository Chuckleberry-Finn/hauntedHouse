// Part 1: Determine the target corner
var _player = instance_nearest(x, y, o_person);
if (_player != noone) {
    var _player_x = _player.x;
    var _player_y = _player.y;

    // Define room corners
    var _corners = [
        [0, 0], [room_width, 0], [0, room_height], [room_width, room_height]
    ];

    // Initialize arrays for farthest and closest corners
    var _farthest_corner = [-1, -1];
    var _closest_corner = [-1, -1];

    // Find the farthest corner from the player
    var _max_distance = -1;
    for (var i = 0; i < array_length(_corners); i++) {
        var _corner_x = _corners[i][0];
        var _corner_y = _corners[i][1];
        var _distance = point_distance(_player_x, _player_y, _corner_x, _corner_y);

        if (_distance > _max_distance) {
            _max_distance = _distance;
            _farthest_corner = [_corner_x, _corner_y];
        }
    }

    // Find the closest corner to the mouse
    var _min_distance = 1000000; // Large initial value
    for (var i = 0; i < array_length(_corners); i++) {
        var _corner_x = _corners[i][0];
        var _corner_y = _corners[i][1];
        var _distance = point_distance(x, y, _corner_x, _corner_y);

        if (_distance < _min_distance) {
            _min_distance = _distance;
            _closest_corner = [_corner_x, _corner_y];
        }
    }

    // Determine if the mouse is between the player and the farthest corner
    var _mouse_to_player_dist = point_distance(x, y, _player_x, _player_y);
    var _player_to_corner_dist = point_distance(_player_x, _player_y, _farthest_corner[0], _farthest_corner[1]);
    var _mouse_to_corner_dist = point_distance(x, y, _farthest_corner[0], _farthest_corner[1]);

    if (_mouse_to_player_dist < _player_to_corner_dist && _mouse_to_corner_dist < _player_to_corner_dist) {
        // Prioritize the farthest corner if the mouse is between the player and the corner
        _target_corner = _farthest_corner;
    } else {
        // Otherwise, choose the closest corner to the mouse
        _target_corner = _closest_corner;
    }
}

// Handle overlap at spawn with non-solid furniture
var _overlapping_furniture = instance_place(x, y, o_furniture);
if (_overlapping_furniture != noone && !_overlapping_furniture.solid) {
    // Move the mouse away from the non-solid furniture
    var _escape_dir = point_direction(x, y, _overlapping_furniture.x, _overlapping_furniture.y);
    x += lengthdir_x(_scurry_speed, _escape_dir);
    y += lengthdir_y(_scurry_speed, _escape_dir);
}

// Part 2: Navigate toward the target corner
if (_target_corner != noone) {
    var _corner_x = _target_corner[0];
    var _corner_y = _target_corner[1];
    var _direction_to_corner = point_direction(x, y, _corner_x, _corner_y);

    // Check for nearby solid furniture to follow
    var _target_furniture = noone;
    with (o_furniture) {
        if (solid && point_distance(x, y, other.x, other.y) < other._escape_distance) {
            _target_furniture = id; // Only interact with solid furniture
            break;
        }
    }

    if (_target_furniture != noone) {
        // Run along the edge of solid furniture with corner detection
        var _future_x = x + lengthdir_x(_scurry_speed, _direction_to_corner);
        var _future_y = y + lengthdir_y(_scurry_speed, _direction_to_corner);

        if (collision_point(_future_x, _future_y, _target_furniture, false, true)) {
            // Handle corner case by "sliding" along the edge
            var _slide_dir = point_direction(x, y, _target_furniture.x, _target_furniture.y);
            if (place_meeting(x + lengthdir_x(_scurry_speed, _slide_dir), y + lengthdir_y(_scurry_speed, _slide_dir), _target_furniture)) {
                _scurry_dir = _slide_dir; // Slide along the edge
            } else {
                _scurry_dir += choose(-10, 10); // Adjust slightly
            }
        } else {
            _scurry_dir = _direction_to_corner; // Follow normal path
        }
    } else {
        // No solid furniture nearby, head directly to the corner
        _scurry_dir = _direction_to_corner;
    }

    // Move in the current direction
    var _new_x = x + lengthdir_x(_scurry_speed, _scurry_dir);
    var _new_y = y + lengthdir_y(_scurry_speed, _scurry_dir);
    if (!collision_line(x, y, _new_x, _new_y, o_furniture, false, true)) {
        x = _new_x;
        y = _new_y;
    } else {
        // Incrementally adjust direction to prevent getting stuck
        _scurry_dir += choose(-15, 15);
    }

    // Always face the direction of movement, with a -90 adjustment
    image_angle = _scurry_dir + 90;

    // Check if the mouse has reached the target corner
    if (point_distance(x, y, _corner_x, _corner_y) < _edge_distance) {
		
		for (var i = 0; i < array_length(global.current_room.objects); i++) {
		    var obj_data = global.current_room.objects[i];
		    var obj_type = asset_get_index(obj_data[? "type"]);
		    if (obj_type == object_index) {
				array_delete(global.current_room.objects, i, 1);
			}
		}
		
        instance_destroy(); // Delete the mouse upon reaching the corner
    }
}


	if (!audio_is_playing(_current_sound)) {
	    // Random chance to decide whether a sound should play (e.g., 50% chance)
	    if (random(1) < 0.05) {
	        // Randomly select one sound from the pool of creaky sounds
	        var sound_pool = [snd_mouse1, snd_mouse2, snd_mouse3, snd_mouse4, snd_mouse5, snd_mouse6]; // Add your sounds to this array
	        var random_sound = sound_pool[irandom(array_length(sound_pool) - 1)];
        
	        // Play the selected sound
	        audio_play_sound(random_sound, 1, false);
        
	        // Track the current sound playing
	        _current_sound = random_sound;
	    }
	}