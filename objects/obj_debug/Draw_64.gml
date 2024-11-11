/// Draw GUI Event

// Set the size of each room square and connection squares
var room_size = 8; // Room squares are 8x8 pixels
var padding = 4;   // Gap between rooms (and size of connection squares)
var offset_y = 20; // Distance from the top of the screen
var gap_from_right = 20; // Distance from the right side of the screen

// Define the full grid size (20x20 square)
var grid_size = 20;

// Calculate the total width and height of the minimap
var minimap_width = (grid_size * (room_size + padding)) - padding;
var minimap_height = (grid_size * (room_size + padding)) - padding;

// Calculate the offset for aligning to the top-right corner
var offset_x = display_get_gui_width() - minimap_width - gap_from_right;

// Get the current room object from the global variable
var current_room = global.current_room;
var grid = global.houseHandler.grid;

// Iterate through the grid to draw the minimap
for (var _y = 0; _y < grid_size; _y++) {
    for (var _x = 0; _x < grid_size; _x++) {
        // Calculate the screen position for this cell
        var screen_x = offset_x + _x * (room_size + padding);
        var screen_y = offset_y + _y * (room_size + padding);

        // Check if a room exists at this grid location
        var room_id = grid[# _x, _y];

        if (room_id != -1) {
            var _room = global.house_map[0][room_id];

            // Set color based on whether this is the current room
            if (_room == current_room) {
                draw_set_color(c_lime); // Draw current room in lime green
            } else {
                draw_set_color(c_white); // Draw other rooms in white
            }

            // Draw the room square
            draw_set_alpha(0.8);
            draw_rectangle(screen_x, screen_y, screen_x + room_size, screen_y + room_size, false);

            // Draw connection squares centered in the gap between rooms
            draw_set_alpha(0.5); // 60% transparency for connections
            var directions = [
                {_x: 0, _y: -1}, // North
                {_x: 1, _y: 0},  // East
                {_x: 0, _y: 1},  // South
                {_x: -1, _y: 0}  // West
            ];

            for (var d = 0; d < 4; d++) {
                var connected_room_id = _room.connected_room_ids[d];
                if (connected_room_id != undefined) {
                    var connected_room = global.house_map[_room.floor_id][connected_room_id];
                    if (connected_room != undefined) {
                        // Calculate the position of the connected room
                        var connected_x = offset_x + connected_room._x * (room_size + padding);
                        var connected_y = offset_y + connected_room._y * (room_size + padding);

                        // Draw the connection square centered within the gap
                        draw_set_color(c_white);

                        // Adjust connection square to be fully within the gap, not overlapping rooms
                        if (d == 0) { // North
                            draw_rectangle(
                                screen_x + (room_size / 2) - (padding / 2),
                                screen_y - (padding / 2) - 1,
                                screen_x + (room_size / 2) + (padding / 2),
                                screen_y - (padding / 2) + 1,
                                false
                            );
                        } else if (d == 1) { // East
                            draw_rectangle(
                                screen_x + room_size + (padding / 2) - 1,
                                screen_y + (room_size / 2) - (padding / 2),
                                screen_x + room_size + (padding / 2) + 1,
                                screen_y + (room_size / 2) + (padding / 2),
                                false
                            );
                        } else if (d == 2) { // South
                            draw_rectangle(
                                screen_x + (room_size / 2) - (padding / 2),
                                screen_y + room_size + (padding / 2) - 1,
                                screen_x + (room_size / 2) + (padding / 2),
                                screen_y + room_size + (padding / 2) + 1,
                                false
                            );
                        } else if (d == 3) { // West
                            draw_rectangle(
                                screen_x - (padding / 2) - 1,
                                screen_y + (room_size / 2) - (padding / 2),
                                screen_x - (padding / 2) + 1,
                                screen_y + (room_size / 2) + (padding / 2),
                                false
                            );
                        }
                    }
                }
            }
        }
        draw_set_alpha(1); // Reset alpha
    }
}
