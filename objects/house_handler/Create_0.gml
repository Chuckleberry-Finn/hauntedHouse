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

    var house_map = array_create(num_floors); // Initialize house_map as an array of floors

    // Initialize each floor as an empty array
    for (var _i = 0; _i < num_floors; _i++) {
        house_map[_i] = []; // Ensure each floor is an array
    }

    var room_count = 0;
    var grid_size = 20; // Grid size per floor

    // Directions for expansion: {_x_offset, _y_offset}
    var directions = [
        {_x: 0, _y: -1}, // North
        {_x: 1, _y: 0},  // East
        {_x: 0, _y: 1},  // South
        {_x: -1, _y: 0}  // West
    ];

    // Rooms per floor target
    var target_rooms_per_floor = max_rooms div num_floors;
    var rooms_on_floor = array_create(num_floors, 0); // Track number of rooms on each floor

    // Generate each floor independently
    for (var _floor_id = 0; _floor_id < num_floors; _floor_id++) {
        var expandable_rooms = []; // List to store rooms that can be expanded from
        var floor_rooms = [];

        // Create the first room at the center of the grid for each floor
        var _start_x = grid_size div 2;
        var _start_y = grid_size div 2;
        var _current_room = create_room(room_count, _floor_id);
        _current_room._x = _start_x;
        _current_room._y = _start_y;

        // Assign a unique room ID to the first room
        _current_room.room_id = room_count;

        // Add the first room to the current floor
        floor_rooms = [_current_room];
        room_count++;

        expandable_rooms = [_current_room]; // Initialize expandable rooms list

        while (array_length(floor_rooms) < target_rooms_per_floor) {
            var _index = irandom(array_length(expandable_rooms) - 1);
            var _room = expandable_rooms[_index];

            randomize();
            array_shuffle(directions); // Shuffle directions for varied layouts
            var _expanded = false;

            // Try to expand in a random direction
            for (var _i = 0; _i < 4; _i++) {
                var _dir = directions[_i];
                var _new_x = _room._x + _dir._x;
                var _new_y = _room._y + _dir._y;

                // Check if the new coordinates are within bounds and unoccupied
                if (_new_x >= 0 && _new_x < grid_size && _new_y >= 0 && _new_y < grid_size) {
                    var _valid_position = true;
                    // Check if the room already exists in the current floor
                    for (var _room_index = 0; _room_index < array_length(floor_rooms); _room_index++) {
                        var _otherRoom = floor_rooms[_room_index];
                        if (_otherRoom._x == _new_x && _otherRoom._y == _new_y) {
                            _valid_position = false;
                            break;
                        }
                    }

                    if (_valid_position) {
                        // Create the new room
                        var _new_room = create_room(room_count, _floor_id);
                        _new_room._x = _new_x;
                        _new_room._y = _new_y;

                        // Assign a unique room ID to the new room
                        _new_room.room_id = room_count;

                        // Add room to the floor
                        array_push(floor_rooms, _new_room);
                        room_count++;
                        array_push(expandable_rooms, _new_room);
                        _expanded = true;

                        break;
                    }
                }
            }

            // Remove room from expandable list if no expansion was possible
            if (!_expanded) {
                array_delete(expandable_rooms, _index, 1);
            }
        }

        // After floor is generated, add it to the house_map
        house_map[_floor_id] = floor_rooms;
    }

    // Ensure every room has at least one path to every other room on the same floor
    for (var _floor_id = 0; _floor_id < num_floors; _floor_id++) {
        var floor_rooms = house_map[_floor_id];

        // Create a list of all rooms to connect
        var _connections = [];
        
        // Create connections between adjacent rooms (minimum spanning tree approach)
        for (var _i = 0; _i < array_length(floor_rooms); _i++) {
            var _room = floor_rooms[_i];
            var _neighbors = [];

            // Check for neighboring rooms in 4 directions and store them
            for (var _dir = 0; _dir < 4; _dir++) {
                var _check_x = _room._x + directions[_dir]._x;
                var _check_y = _room._y + directions[_dir]._y;

                // Check bounds and find neighbor room
                if (_check_x >= 0 && _check_x < grid_size && _check_y >= 0 && _check_y < grid_size) {
                    var _neighbor_room = undefined;
                    for (var _j = 0; _j < array_length(floor_rooms); _j++) {
                        var _otherRoom = floor_rooms[_j];
                        if (_otherRoom._x == _check_x && _otherRoom._y == _check_y) {
                            _neighbor_room = _otherRoom;
                            break;
                        }
                    }

                    if (_neighbor_room != undefined) {
						array_push(_neighbors, _neighbor_room)
                    }
                }
            }

            // If the room has any valid neighbors, connect them
            if (array_length(_neighbors) > 0) {
                var _neighbor = _neighbors[irandom(array_length(_neighbors) - 1)];
                var _connection_dir = -1;
                var _opposite_dir = -1;

                // Determine the connection direction based on relative position
                if (_room._x == _neighbor._x) {
                    if (_room._y < _neighbor._y) {
                        _connection_dir = 2;  // South
                        _opposite_dir = 0;    // North
                    } else {
                        _connection_dir = 0;  // North
                        _opposite_dir = 2;    // South
                    }
                } else if (_room._y == _neighbor._y) {
                    if (_room._x < _neighbor._x) {
                        _connection_dir = 1;  // East
                        _opposite_dir = 3;    // West
                    } else {
                        _connection_dir = 3;  // West
                        _opposite_dir = 1;    // East
                    }
                }

                if (_connection_dir != -1) {
                    _room.connected_room_ids[_connection_dir] = _neighbor.room_id;
                    _neighbor.connected_room_ids[_opposite_dir] = _room.room_id;

                    _room.texture_of_walls[_connection_dir] = "wall_door_texture";
                    _neighbor.texture_of_walls[_opposite_dir] = "wall_door_texture";
                }
            }
        }
    }

    // Now, establish connections between floors
    for (var _i = 0; _i < num_floors - 1; _i++) {
        var floor_rooms = house_map[_i];
        var next_floor_rooms = house_map[_i + 1];
        var connection_count = 0;

        // Randomly decide whether to create 2 or 3 connections between floors
        var connections_to_create = irandom_range(2, 3);

        // Connect rooms across floors with the decided number of connections
        while (connection_count < connections_to_create) {
            var _room1 = floor_rooms[irandom(array_length(floor_rooms) - 1)];
            var _room2 = next_floor_rooms[irandom(array_length(next_floor_rooms) - 1)];

            // Ensure rooms aren't already connected
            var already_connected = false;

            // Check if the room ID is already in the connected_room_ids array
            for (var _j = 0; _j < array_length(_room1.connected_room_ids); _j++) {
                if (_room1.connected_room_ids[_j] == _room2.room_id) {
                    already_connected = true;
                    break; // Exit loop once connection is found
                }
            }

            // If not connected, establish the connection
            if (!already_connected) {
                var available_directions = [0, 1, 2, 3];
                array_shuffle(available_directions); // Randomize the available directions

                for (var _dir = 0; _dir < array_length(available_directions); _dir++) {
                    var _dir = available_directions[_dir];
                    if (_room1.connected_room_ids[_dir] == undefined) {
                        _room1.connected_room_ids[_dir] = _room2.room_id;
                        _room2.connected_room_ids[(_dir + 2) % 4] = _room1.room_id;
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
    var object_list = ["o_plant", "o_stool", "o_rug1", "o_shelf"];
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