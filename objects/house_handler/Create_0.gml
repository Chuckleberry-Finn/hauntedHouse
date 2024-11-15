function create_room(r_id, f_id) {
    return {
        room_id: r_id,
        floor_id: f_id,
        connected_room_ids: [undefined, undefined, undefined, undefined], // [north, east, south, west]
        texture_of_walls: ["wall_texture", "wall_texture", "wall_texture", "wall_texture"], // Default textures for each wall
        texture_of_floor: "floor_texture", // Default floor texture
        stairs_up: false,
        stairs_down: false,
        hole_in_floor: false,
        generated: false,
        objects: []
    };
}

//enter_room("north", current_room_id, current_floor_id);

function generate_house_map(max_rooms, num_floors) {
    show_debug_message("Generating house map...");
	
    global.house_map = [];
    var room_count = 0;
    var grid_size = 20;
    var grid = ds_grid_create(grid_size, grid_size);
    ds_grid_clear(grid, -1);

    // Store the grid in the house handler object
    global.houseHandler.grid = grid;

    // Define directions as {_x_offset, _y_offset}
    var directions = [
        {_x: 0, _y: -1}, // North
        {_x: 1, _y: 0},  // East
        {_x: 0, _y: 1},  // South
        {_x: -1, _y: 0}  // West
    ];

    // Create the first room at the center of the grid
    var start_x = grid_size div 2;
    var start_y = grid_size div 2;
    var current_room = create_room(room_count, 0);
    current_room._x = start_x;
    current_room._y = start_y;
    grid[# start_x, start_y] = room_count;
    global.house_map[0] = [current_room];
    room_count++;

    // List to store rooms that can be expanded from
    var expandable_rooms = [current_room];

    while (room_count < max_rooms && array_length(expandable_rooms) > 0) {
        // Randomly pick a room to expand from
        var index = irandom(array_length(expandable_rooms) - 1);
        var _room = expandable_rooms[index];

		randomize();
        // Shuffle directions for more varied layouts
        array_shuffle(directions);
        var expanded = false;

        // Try to expand in a random direction
        for (var i = 0; i < 4; i++) {
            var dir = directions[i];
            var new_x = _room._x + dir._x;
            var new_y = _room._y + dir._y;

            // Check if the new coordinates are within bounds and unoccupied
            if (new_x >= 0 && new_x < grid_size && new_y >= 0 && new_y < grid_size && grid[# new_x, new_y] == -1) {
                // Create a new room
                var new_room = create_room(room_count, _room.floor_id);
                new_room._x = new_x;
                new_room._y = new_y;

                // Ensure there's space in the house map for this new room
                if (array_length(global.house_map[_room.floor_id]) <= room_count) {
                    array_resize(global.house_map[_room.floor_id], room_count + 1);
                }

                // Add the new room to the house map and grid
                global.house_map[_room.floor_id][room_count] = new_room;
                grid[# new_x, new_y] = room_count;
                room_count++;

                // Establish connections
                var connection_dir = i;
                var opposite_dir = (i + 2) % 4;

                _room.connected_room_ids[connection_dir] = new_room.room_id;
                new_room.connected_room_ids[opposite_dir] = _room.room_id;

                // Assign door textures for connected walls
                _room.texture_of_walls[connection_dir] = "wall_door_texture";
                new_room.texture_of_walls[opposite_dir] = "wall_door_texture";

                // Add the new room to the list of expandable rooms
                array_push(expandable_rooms, new_room);
                expanded = true;
                break;
            }
        }

        // If no expansion was possible from this room, remove it from the list
        if (!expanded) {
            array_delete(expandable_rooms, index, 1);
        }
    }

    show_debug_message("House map generated successfully!");
    return global.house_map;
}



function enter_room(door, room_id, floor_id) {
    show_debug_message("Entering room " + string(room_id) + " on floor " + string(floor_id));

    if (array_length(global.house_map) <= floor_id || !is_array(global.house_map[floor_id])) {
        show_debug_message("Error: Floor " + string(floor_id) + " does not exist.");
        return;
    }

    if (array_length(global.house_map[floor_id]) <= room_id || global.house_map[floor_id][room_id] == undefined) {
        show_debug_message("Error: Room " + string(room_id) + " does not exist.");
        return;
    }

    var _room = global.house_map[floor_id][room_id];
    show_debug_message("Room loaded successfully");

	var player =  global.player

    with (all) {
        if (object_index != obj_light && id != player && !(x == -1 && y == -1)) {
            instance_destroy();
        }
    }

    if (!_room.generated) {
        fill_room(_room);
    }

    // Set wall textures
    global.topWall.p_texture = _room.texture_of_walls[0];
    global.rightWall.p_texture = _room.texture_of_walls[1];
    global.bottomWall.p_texture = _room.texture_of_walls[2];
    global.leftWall.p_texture = _room.texture_of_walls[3];

    // Set floor texture
    global.the_floor.p_texture = _room.texture_of_floor;

    global.current_room = _room;

    //show_debug_message("Textures set. Placing objects...");

	global.current_room_objs = []
    for (var i = 0; i < array_length(_room.objects); i++) {
        var obj_data = _room.objects[i];
        var obj_type = asset_get_index(obj_data[? "type"]);
        if (obj_type != -1) {
            var o = instance_create_layer(obj_data[? "x"], obj_data[? "y"], "Instances", obj_type);
			array_push(global.current_room_objs, o);
		}
    }
	
	// Position player near the door they entered from
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
}


function fill_room(_room) {
    show_debug_message("Filling room " + string(_room.room_id));
    var object_list = ["o_plant", "o_stool", "o_rug1", "o_shelf"];
    var num_objects = irandom_range(2, 5);

    for (var i = 0; i < num_objects; i++) {
        var random_x = irandom_range(32, room_width-32);
        var random_y = irandom_range(32, room_height-32);

        var random_index = irandom(array_length(object_list) - 1);
        var selected_object = object_list[random_index];

        var obj_data = ds_map_create();
        ds_map_add(obj_data, "type", selected_object);
        ds_map_add(obj_data, "x", random_x);
        ds_map_add(obj_data, "y", random_y);

        array_push(_room.objects, obj_data);
    }

    _room.generated = true;
    //show_debug_message("Room " + string(_room.room_id) + " filled with objects");
}