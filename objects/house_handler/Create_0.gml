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
    for (var i = 0; i < num_floors; i++) {
        house_map[i] = []; // Ensure each floor is an array
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

    // Create the first room at the center of the grid, on the first floor (0)
    var start_x = grid_size div 2;
    var start_y = grid_size div 2;
    var current_room = create_room(room_count, 0);
    current_room._x = start_x;
    current_room._y = start_y;

    // Assign a unique room ID to the first room
    current_room.room_id = room_count;

    house_map[0] = [current_room]; // Initialize floor 0 as an array and add the first room
    room_count++;

    // List to store rooms that can be expanded from
    var expandable_rooms = [current_room];

    // Rooms per floor target
    var target_rooms_per_floor = max_rooms div num_floors;
    var rooms_on_floor = array_create(num_floors, 0); // Track number of rooms on each floor

    while (room_count < max_rooms && array_length(expandable_rooms) > 0) {
        var index = irandom(array_length(expandable_rooms) - 1);
        var _room = expandable_rooms[index];

        randomize();
        array_shuffle(directions); // Shuffle directions for varied layouts
        var expanded = false;

        // Try to expand in a random direction
        for (var i = 0; i < 4; i++) {
            var dir = directions[i];
            var new_x = _room._x + dir._x;
            var new_y = _room._y + dir._y;
            var new_floor_id = _room.floor_id;

            // Debugging: Print the value of new_floor_id
            show_debug_message("Attempting to move to new_floor_id: " + string(new_floor_id));

            // Check if the new coordinates are within bounds and unoccupied on the same floor
            if (new_x >= 0 && new_x < grid_size && new_y >= 0 && new_y < grid_size) {
                var valid_position = true;
                // Check if the room already exists in the current floor
                for (var room_index = 0; room_index < array_length(house_map[new_floor_id]); room_index++) {
                    var _otherRoom = house_map[new_floor_id][room_index];
                    if (_otherRoom._x == new_x && _otherRoom._y == new_y) {
                        valid_position = false;
                        break;
                    }
                }

                if (valid_position) {
                    // Only allow moving up to the next floor (adjacent floor) if possible
                    if (rooms_on_floor[new_floor_id] >= target_rooms_per_floor) {
                        if (new_floor_id < num_floors - 1) {
                            new_floor_id++; // Move to the next floor, but check that it doesn't exceed bounds
                        }
                    } else if (rooms_on_floor[new_floor_id] > target_rooms_per_floor) {
                        if (new_floor_id > 0) {
                            new_floor_id--; // Move to the previous floor, but check that it doesn't go below 0
                        }
                    }

                    // Debugging: Print the value of new_floor_id after modification
                    show_debug_message("After modification, new_floor_id is: " + string(new_floor_id));

                    // Ensure new_floor_id is within bounds before proceeding
                    if (new_floor_id >= 0 && new_floor_id < num_floors) {
                        // Create the new room
                        var new_room = create_room(room_count, new_floor_id);
                        new_room._x = new_x;
                        new_room._y = new_y;

                        // Assign a unique room ID to the new room
                        new_room.room_id = room_count;

                        // Add room to the house map for the correct floor
                        array_push(house_map[new_floor_id], new_room); // Add room to the house map
                        room_count++;
                        rooms_on_floor[new_floor_id]++; // Increment room count for the floor

                        // Track room connections
                        var connection_dir = i;
                        var opposite_dir = (i + 2) % 4;

                        _room.connected_room_ids[connection_dir] = new_room.room_id;
                        new_room.connected_room_ids[opposite_dir] = _room.room_id;

                        _room.texture_of_walls[connection_dir] = "wall_door_texture";
                        new_room.texture_of_walls[opposite_dir] = "wall_door_texture";

                        // Add new room to expandable rooms
                        array_push(expandable_rooms, new_room);
                        expanded = true;
                        break;
                    } else {
                        // Debugging: Print the error if new_floor_id is out of bounds
                        show_debug_message("ERROR: new_floor_id is out of bounds: " + string(new_floor_id));
                    }
                }
            }
        }

        // Remove room from expandable list if no expansion was possible
        if (!expanded) {
            array_delete(expandable_rooms, index, 1);
        }
    }

    // Ensure at least two connections per floor across floors
    for (var i = 0; i < num_floors - 1; i++) {
        // Get rooms for the floor above and below
        var floor_rooms = house_map[i];
        var next_floor_rooms = house_map[i + 1];
        var connection_count = 0;

        // Connect rooms across floors with at least 2 connections
        while (connection_count < 2) {
            var room1 = floor_rooms[irandom(array_length(floor_rooms) - 1)];
            var room2 = next_floor_rooms[irandom(array_length(next_floor_rooms) - 1)];

            // Ensure rooms aren't already connected
            var already_connected = false;

            // Check if the room ID is already in the connected_room_ids array
            for (var j = 0; j < array_length(room1.connected_room_ids); j++) {
                if (room1.connected_room_ids[j] == room2.room_id) {
                    already_connected = true;
                    break; // Exit loop once connection is found
                }
            }

            // If not connected, establish the connection
            if (!already_connected) {
                room1.connected_room_ids[irandom(3)] = room2.room_id;
                room2.connected_room_ids[irandom(3)] = room1.room_id;
                connection_count++;
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