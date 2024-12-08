/// Server Handler Create Event

global.players = [];  // Track all connected players

// Generate the house map (array)
global.houseHandler = instance_create_depth(-1, -1, -1, house_handler);
global.house_map = global.houseHandler.generate_house_map(global.max_rooms, global.num_floors); 


// Ensure the first room is set
if (array_length(global.house_map) > 0) {
    global.current_room = global.house_map[0];  // First room
    show_debug_message("Server: House map generated. Current room set.");
} else {
    show_debug_message("Error: House map generation failed!");
}


// Serialize the house map array using json_stringify
var house_map_json = json_stringify(global.house_map);

// Broadcast house map to all clients on server start
var buffer = buffer_create(256, buffer_grow, 1);
buffer_write(buffer, buffer_u8, 2); // Event type: House map data
buffer_write(buffer, buffer_string, house_map_json); 

// Use the broadcast function
network_broadcast_all(buffer);

buffer_delete(buffer); // Clean up the buffer
show_debug_message("Server: House map generated and broadcast.");