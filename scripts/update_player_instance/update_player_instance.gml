function update_player_instance(data){
	
	var p_socket = data._socket
	var p_x = data._x
	var p_y = data._y
	var room_id = data._room_id
	var facing = data._facing
	
	var player_found = false;
	
	//show_debug_message("global.client_socket_id: " + string(global.client_socket_id));
	//show_debug_message("Updating player instance " + string(p_socket));
	
	if (p_socket == global.client_socket_id) { return };

	for (var i = array_length(global.other_players) - 1; i >= 0; i--) {

	    if (instance_exists(global.other_players[i])) {
			if (global.other_players[i].inst_socket == p_socket) {
				if (room_id == global.current_room.room_id) {
					player_found = global.other_players[i];
				} else {
					instance_destroy(global.other_players[i]);
					array_delete(global.other_players, i, 1);
				}
				break;
			}
		
	    } else {
	        array_delete(global.other_players, i, 1);
			break;
	    }
	}
		
	if (room_id != global.current_room.room_id) { return }
		
	if (!player_found) {
		var new_player = instance_create_layer(p_x, p_y, "Instances", o_person ); 
		new_player.inst_room_id = room_id;
		new_player.inst_socket = p_socket;
		new_player.image_angle = facing ;
							
		player_found = new_player
		array_push(global.other_players, player_found);
		show_debug_message("Created new player instance for socket " + string(p_socket) + " X:" + string(p_x) + " Y:" + string(p_y));

	} else {
						
		player_found.x = p_x
		player_found.y = p_y
		player_found.image_angle = facing
						
		//show_debug_message("Updated player instance for socket " + string(p_socket) + " X:" + string(p_x) + " Y:" + string(p_y));
	}
}