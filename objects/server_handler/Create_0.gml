global.house_map = global.houseHandler.generate_house_map(global.max_rooms, global.num_floors); 


if (array_length(global.house_map) > 0) {
    global.current_room = global.house_map[0];
    show_debug_message("Server: House map generated. Current room set.");
} else {
    show_debug_message("Error: House map generation failed!");
}