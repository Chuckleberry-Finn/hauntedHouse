function create_room(r_id, f_id) {
    return {
        room_id: r_id,
        floor_id: f_id,
        connected_room_ids: [undefined, undefined, undefined, undefined], // [north, east, south, west]
        texture_of_walls: ["wall_texture", "wall_texture", "wall_texture", "wall_texture"], // Default textures for each wall
        texture_of_floor: "floor_texture", // Default floor texture
        hole_in_floor: false,
        generated: false,
        objects: []
    };
}


function generate_house_map(max_rooms, num_floors) {
    show_debug_message("Generating house map...");

    var house_map = array_create(num_floors); // Initialize house_map for each floor

    // Directions for expansion: North, East, South, West
    var directions = [
        {_x: 0, _y: -1},  // North
        {_x: 1, _y: 0},   // East
        {_x: 0, _y: 1},   // South
        {_x: -1, _y: 0}   // West
    ];

    var grid_size = 20;
    var target_rooms_per_floor = max_rooms div num_floors;
    var room_count = 0;

    // Generate each floor independently with a clustered layout
    for (var _floor_id = 0; _floor_id < num_floors; _floor_id++) {
        var floor_rooms = [];
        var expandable_rooms = [];  // List of rooms we can expand from
        var visited_rooms = [];     // List to track visited rooms to prevent duplicates

        // Create the first room at the center of the grid
        var _start_x = grid_size div 2;
        var _start_y = grid_size div 2;
        var _current_room = create_room(room_count, _floor_id);
        _current_room._x = _start_x;
        _current_room._y = _start_y;
        _current_room.room_id = room_count++;
        floor_rooms = [_current_room];
        expandable_rooms = [_current_room]; // Start with the first room as expandable
        visited_rooms = [_current_room];   // Mark the first room as visited

        // Expand rooms in random directions for a clustered layout
        while (array_length(floor_rooms) < target_rooms_per_floor) {
            var _room = expandable_rooms[irandom(array_length(expandable_rooms) - 1)]; // Randomly pick an expandable room
            randomize(); // Randomize for random directions
            array_shuffle(directions); // Shuffle directions to create varied layouts

            var _expanded = false;

            // Try expanding in random directions to create a clustered layout
            for (var _i = 0; _i < 4; _i++) {
                var _dir = directions[_i];
                var _new_x = _room._x + _dir._x;
                var _new_y = _room._y + _dir._y;

                // Check if the new position is within bounds and not already occupied
                if (_new_x >= 0 && _new_x < grid_size && _new_y >= 0 && _new_y < grid_size) {
                    var _valid_position = true;

                    // Check if the new position is occupied
                    for (var _room_index = 0; _room_index < array_length(floor_rooms); _room_index++) {
                        var _otherRoom = floor_rooms[_room_index];
                        if (_otherRoom._x == _new_x && _otherRoom._y == _new_y) {
                            _valid_position = false;
                            break;
                        }
                    }

                    if (_valid_position) {
                        var _new_room = create_room(room_count, _floor_id);
                        _new_room._x = _new_x;
                        _new_room._y = _new_y;
                        _new_room.room_id = room_count++;

                        // Add the new room to the floor
                        array_push(floor_rooms, _new_room);
                        array_push(expandable_rooms, _new_room); // Mark it as expandable
                        array_push(visited_rooms, _new_room);   // Mark it as visited
                        connect_rooms(_room, _new_room); // Connect the new room to the existing room

                        _expanded = true;
                        break;  // Exit after expanding to one valid direction
                    }
                }
            }

            // If no expansion was possible, continue trying with other rooms
            if (!_expanded) {
                continue; // Continue to the next room in the expandable list
            }
        }

        // After the floor is generated, add it to the house_map
        house_map[_floor_id] = floor_rooms;

        // ** Step 1: Check and Connect Dead-End Rooms**
        // Find dead-end rooms and connect them to nearby rooms if possible
        for (var _i = 0; _i < array_length(floor_rooms); _i++) {
            var _room = floor_rooms[_i];
            
            // If the room has only one connection, it's considered a dead-end
            var _connected_count = 0;
            for (var _dir = 0; _dir < 4; _dir++) {
                if (_room.connected_room_ids[_dir] != undefined) {
                    _connected_count++;
                }
            }

            if (_connected_count == 1) {
                // Room is a dead-end, try to find nearby unconnected rooms
                for (var _dir = 0; _dir < 4; _dir++) {
                    var _new_x = _room._x + directions[_dir]._x;
                    var _new_y = _room._y + directions[_dir]._y;

                    // Check if the new position is within bounds
                    if (_new_x >= 0 && _new_x < grid_size && _new_y >= 0 && _new_y < grid_size) {
                        // Find a nearby unconnected room
                        for (var _j = 0; _j < array_length(floor_rooms); _j++) {
                            var _neighbor = floor_rooms[_j];
                            if (_neighbor._x == _new_x && _neighbor._y == _new_y) {
                                // Check if the neighbor is unconnected
                                var _can_connect = false;
                                for (var _k = 0; _k < 4; _k++) {
                                    if (_neighbor.connected_room_ids[_k] == undefined) {
                                        _can_connect = true;
                                        break;
                                    }
                                }

                                // Connect if possible
                                if (_can_connect) {
                                    connect_rooms(_room, _neighbor); // Connect the dead-end room to the neighbor
                                    break; // Exit after successfully connecting
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Now, establish 2-3 two-way connections between adjacent floors
    for (var _i = 0; _i < num_floors - 1; _i++) {
        var floor_rooms = house_map[_i];
        var next_floor_rooms = house_map[_i + 1];
        var connection_count = 0;
        var connections_to_create = irandom_range(2, 3); // Create 2 or 3 connections between floors

        // Ensure each pair of floors has 2-3 connections
        while (connection_count < connections_to_create) {
            // Randomly choose rooms from both floors to connect
            var _room1 = floor_rooms[irandom(array_length(floor_rooms) - 1)];
            var _room2 = next_floor_rooms[irandom(array_length(next_floor_rooms) - 1)];

            // Ensure rooms aren't already connected
            var already_connected = false;
            for (var _j = 0; _j < array_length(_room1.connected_room_ids); _j++) {
                if (_room1.connected_room_ids[_j] == _room2.room_id) {
                    already_connected = true;
                    break;
                }
            }

            // If not connected, establish the connection using unused directions
            if (!already_connected) {
                var available_directions = get_unused_connection_directions(_room1);
                array_shuffle(available_directions);

                // Try to create the connection in an unused direction
                for (var _dir = 0; _dir < array_length(available_directions); _dir++) {
                    var _direction = available_directions[_dir];
                    if (_room1.connected_room_ids[_direction] == undefined) {
                        _room1.connected_room_ids[_direction] = _room2.room_id;
                        _room2.connected_room_ids[(_direction + 2) % 4] = _room1.room_id;
                        _room1.texture_of_walls[_direction] = "wall_door_texture";  // Add door texture
                        _room2.texture_of_walls[(_direction + 2) % 4] = "wall_door_texture";  // Add door texture
                        connection_count++;
                        break; // Once a valid connection is made, break the loop
                    }
                }
            }
        }
    }

    show_debug_message("House map generated successfully!");
    return house_map;
}

// Helper to check if a room has been visited
function is_room_visited(visited_rooms, room) {
    for (var i = 0; i < array_length(visited_rooms); i++) {
        if (visited_rooms[i] == room) {
            return true;
        }
    }
    return false;
}

// Function to get unused connection directions for a room
function get_unused_connection_directions(room) {
    var unused_directions = [];
    for (var i = 0; i < 4; i++) {
        if (room.connected_room_ids[i] == undefined) {
            array_push(unused_directions, i);
        }
    }
    return unused_directions;
}

// Function to connect two rooms
function connect_rooms(_room1, _room2) {
    var _connection_dir = -1;
    var _opposite_dir = -1;

    // Determine the direction to connect the rooms
    if (_room1._x == _room2._x) {
        if (_room1._y < _room2._y) {
            _connection_dir = 2;  // South
            _opposite_dir = 0;    // North
        } else {
            _connection_dir = 0;  // North
            _opposite_dir = 2;    // South
        }
    } else if (_room1._y == _room2._y) {
        if (_room1._x < _room2._x) {
            _connection_dir = 1;  // East
            _opposite_dir = 3;    // West
        } else {
            _connection_dir = 3;  // West
            _opposite_dir = 1;    // East
        }
    }

    if (_connection_dir != -1) {
        _room1.connected_room_ids[_connection_dir] = _room2.room_id;
        _room2.connected_room_ids[_opposite_dir] = _room1.room_id;
        _room1.texture_of_walls[_connection_dir] = "wall_door_texture";
        _room2.texture_of_walls[_opposite_dir] = "wall_door_texture";
    }
}


// Enters a room, supports floor transitions
function enter_room(door, room_id) {
    show_debug_message("Entering room " + string(room_id));

    var found_room = undefined;

    // Search through all floors for the room
    for (var floor_id = 0; floor_id < array_length(global.house_map); floor_id++) {
        for (var i = 0; i < array_length(global.house_map[floor_id]); i++) {
            var _room = global.house_map[floor_id][i];
            if (_room.room_id == room_id) {
                found_room = _room;
                break;
            }
        }
        if (found_room != undefined) break;
    }

    if (found_room == undefined) {
        show_debug_message("Error: Room " + string(room_id) + " does not exist.");
        return;
    }

    show_debug_message("Room loaded successfully");

    var player = global.player;

    // Destroy any other instances that are not the player or lighting objects
    with (all) {
        if (object_index != obj_light && id != player && !(x == -1 && y == -1)) {
            instance_destroy();
        }
    }

    // If the room hasn't been generated, generate it
    if (!found_room.generated) {
        fill_room(found_room);
    }

    // Set wall textures based on the room
    global.topWall.p_texture = found_room.texture_of_walls[0];
    global.rightWall.p_texture = found_room.texture_of_walls[1];
    global.bottomWall.p_texture = found_room.texture_of_walls[2];
    global.leftWall.p_texture = found_room.texture_of_walls[3];

    // Set floor texture
    global.the_floor.p_texture = found_room.texture_of_floor;

    // Update the current room in global state
    global.current_room = found_room;

	global.current_room_objs = []
    for (var i = 0; i < array_length(_room.objects); i++) {
        var obj_data = _room.objects[i];
        var obj_type = asset_get_index(obj_data[? "type"]);
        if (obj_type != -1) {
            var o = instance_create_layer(obj_data[? "x"], obj_data[? "y"], "Instances", obj_type);
			array_push(global.current_room_objs, o);
		}
    }

    // Handle player positioning based on the door they entered through
    switch (door) {
        case "north":
            player.x = room_width / 2;
            player.y = room_height - 50;
            break;
        case "south":
            player.x = room_width / 2;
            player.y = 50;
            break;
        case "east":
            player.x = 50;
            player.y = room_height / 2;
            break;
        case "west":
            player.x = room_width - 50;
            player.y = room_height / 2;
            break;
    }

    // If the player has entered a room on a new floor, ensure the transition is handled
    if (global.current_room.floor_id != floor_id) {
        show_debug_message("Floor transition: " + string(floor_id) + " to " + string(global.current_room.floor_id));
    }
}



// Fills room with random objects
function fill_room(_room) {
    show_debug_message("Filling room " + string(_room.room_id));
    var object_list = [
		"o_plant", "o_stool", "o_rug1", "o_shelf",
		"o_plant", "o_stool", "o_rug1", "o_shelf", 
		"o_mouse"
		];
    var num_objects = irandom_range(2, 5);

    for (var i = 0; i < num_objects; i++) {
        var random_x = irandom_range(room_width * 0.1, room_width * 0.9);
        var random_y = irandom_range(room_height * 0.1, room_height * 0.9);

        var random_index = irandom(array_length(object_list) - 1);
        var selected_object = object_list[random_index];

        var sprite_name = string_delete(selected_object, 1, 2);

        var obj_width = sprite_get_width(asset_get_index(sprite_name));
        var obj_height = sprite_get_height(asset_get_index(sprite_name));

        var adjusted_x = clamp(random_x, obj_width, room_width - obj_width);
        var adjusted_y = clamp(random_y, obj_height, room_height - obj_height);

        var obj_data = ds_map_create();
        ds_map_add(obj_data, "type", selected_object);
        ds_map_add(obj_data, "x", adjusted_x);
        ds_map_add(obj_data, "y", adjusted_y);

        array_push(_room.objects, obj_data);
    }

    _room.generated = true;
}