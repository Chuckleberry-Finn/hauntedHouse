/// Draw GUI Event

// Set the size of each room square and connection squares
var room_size = 8; // Room squares are 8x8 pixels
var padding = 4;   // Gap between rooms (and size of connection squares)
var offset_y = 20; // Distance from the top of the screen
var gap_from_right = 20; // Distance from the right side of the screen

// Define the full grid size (20x20 square)
var grid_size = master.grid_size;

// Calculate the total width and height of the minimap
var minimap_width = (grid_size * (room_size + padding)) - padding;
var minimap_height = (grid_size * (room_size + padding)) - padding;

// Calculate the offset for aligning to the top-right corner
var offset_x = display_get_gui_width() - minimap_width - gap_from_right;

// Get the current room object from the global variable
var current_room = global.current_room;
var house_map = global.house_map; // Use house_map which is a 2D array of rooms

// Draw the room square (8x8) without gaps
draw_set_alpha(0.8);

// Iterate through each floor to draw the minimap
var floor_offset_y = offset_y; // Starting Y offset for the top floor
for (var _floor = 0; _floor < array_length(house_map); _floor++) {
    var floor_rooms = house_map[_floor];

    // Draw the rooms of the current floor
    for (var room_index = 0; room_index < array_length(floor_rooms); room_index++) {
        var _room = floor_rooms[room_index];
        
        // Calculate the screen position for this room
        var screen_x = offset_x + _room._x * (room_size + padding);
        var screen_y = floor_offset_y + _room._y * (room_size + padding);

        // Set color based on whether this is the current room
        if (_room == current_room) {
            draw_set_color(c_lime); // Draw current room in lime green
        } else {
            draw_set_color(c_gray); // Draw other rooms in gray
        }

        // Darken the rooms that are not on the current floor
        if (_room.floor_id != _floor) {
            draw_set_color(c_dkgray); // Dark gray for rooms on different floors
        }

        // Draw the room square
        draw_rectangle(screen_x, screen_y, screen_x + room_size, screen_y + room_size, false);
    }

	draw_set_color(c_gray)
    // Draw connection lines between rooms after all rooms have been drawn
    for (var room_index = 0; room_index < array_length(floor_rooms); room_index++) {
        var _room = floor_rooms[room_index];

        var directions = [
            {_x: 0, _y: -1}, // North
            {_x: 1, _y: 0},  // East
            {_x: 0, _y: 1},  // South
            {_x: -1, _y: 0}  // West
        ];

        for (var d = 0; d < 4; d++) {
            var connected_room_id = _room.connected_room_ids[d];
            if (connected_room_id != undefined && connected_room_id >= 0) { // Check if the ID is valid
                // Search for the connected room by ID
                var connected_room = undefined;
                for (var i = 0; i < array_length(floor_rooms); i++) {
                    if (floor_rooms[i].room_id == connected_room_id) {
                        connected_room = floor_rooms[i];
                        break;
                    }
                }

                if (connected_room != undefined) {
                    // Calculate the position of the connected room
                    var connected_x = offset_x + connected_room._x * (room_size + padding);
                    var connected_y = floor_offset_y + connected_room._y * (room_size + padding);

                    // Calculate the center of the current room and the connected room
                    var start_x = offset_x + _room._x * (room_size + padding) + room_size / 2;
                    var start_y = floor_offset_y + _room._y * (room_size + padding) + room_size / 2;
                    var end_x = connected_x + room_size / 2;
                    var end_y = connected_y + room_size / 2;
                    
                    // Draw a line from the center of the current room to the connected room
                    draw_arrow(start_x, start_y, end_x, end_y, 2); // Draw the connection line
                }
            }
        }
    }

    // Move the offset down for the next floor
    floor_offset_y += grid_size * (room_size + padding) + padding;
}

draw_set_alpha(1); // Reset alpha
