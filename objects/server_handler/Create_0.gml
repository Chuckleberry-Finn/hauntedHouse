global.house_map = global.houseHandler.generate_house_map(global.max_rooms, global.num_floors); 


if (array_length(global.house_map) > 0) {
    //global.current_room = global.house_map[0];
	
	global.player = instance_create_depth(room_width / 2, room_height / 2, 0, o_person);

    show_debug_message("Server: House map generated. Current room set.");
	global.houseHandler.enter_room(0, 0)
	
	var new_player = {
            _socket: global.server_socket,
            _x: global.player.x,
            _y: global.player.y,
            _room_id: global.current_room.room_id,
            _facing: global.player.image_angle
        };
    array_push(global.players, new_player);
	
	
} else {
    show_debug_message("Error: House map generation failed!");
}