
if (async_load[? "type"] == network_type_connect) {
	var succeeded = async_load[? "succeeded"];
	show_debug_message("Client connect:" + succeeded);  //  this is 1 the first time, and then 0 the second time
}


if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"];
    var e_type = buffer_read(buffer, buffer_u8);  // First byte is the event type

    switch (e_type) {
		
		case 8:  // Player Disconnect
            var pp_socket = buffer_read(buffer, buffer_s32);

            // Find and remove the player instance
            for (var i = array_length(global.other_players) - 1; i >= 0; i--) {
                if (global.other_players[i].inst_socket == pp_socket) {
                    instance_destroy(global.other_players[i]);
                    array_delete(global.other_players, i, 1);
                    show_debug_message("Client: Removed player with socket " + string(pp_socket));
                    break;
                }
            }
            break;
		
       case 1:  // Player Position Update
		    var p_socket = buffer_read(buffer, buffer_s32);
		    var p_x = buffer_read(buffer, buffer_f32);
		    var p_y = buffer_read(buffer, buffer_f32);
		    var room_id = buffer_read(buffer, buffer_u32);
		    var facing = buffer_read(buffer, buffer_f32);

		    var found_data = false;

		    // Update Existing Players
		    for (var i = 0; i < array_length(global.players); i++) {
		        if (global.players[i]._socket == p_socket) {
		            found_data = global.players[i];
		            break;
		        }
		    }

			if (!found_data) {
				//show_debug_message("Creating player data for socket: " + string(p_socket));
				var new_player = { _socket: p_socket, _x: p_x, _y: p_y, _room_id: room_id, _facing: facing };
				found_data = new_player
				array_push(global.players, found_data);
			}

		    if (found_data) {
			    if (p_socket == global.client_socket_id) {
			        //show_debug_message("Received own socket ID. Ignoring player creation.");

			    } else {
					
					found_data._x = p_x;
		            found_data._y = p_y;
		            found_data._room_id = room_id;
		            found_data._facing = facing;
					
					update_player_instance(found_data)
				}
			}
		    break;
       

        case 2: //connection - send housemap, players, and socket number
            var house_map_json = buffer_read(buffer, buffer_string); 
			var client_socket = buffer_read(buffer, buffer_s32);
			
			var players_json = buffer_read(buffer, buffer_string); 
			
            global.house_map = json_parse(house_map_json); 
            show_debug_message("Client: Received house map.");
			
			global.players = json_parse(players_json);
			
			if !global.player {
				global.client_socket_id = client_socket
				global.player = instance_create_depth(room_width / 2, room_height / 2, 0, o_person);
				global.houseHandler.enter_room(0, 0)
			}
            break;

        case 3:  // Lightning Update
            var lightning_triggered = buffer_read(buffer, buffer_bool);
            if (lightning_triggered) {
                global.weatherHandler.lighting_triggered = true;
                show_debug_message("Client: Lightning triggered.");
            }
            break;
			
		case 7:  // Room Objects Update from Server
            var obj_json = buffer_read(buffer, buffer_string);
            var room_update = json_parse(obj_json);
            var floor_id = room_update.floor_id;
            var room_id = room_update.room_id;
            var _room = global.house_map[floor_id][room_id];

            if (_room.room_id == room_id) {
                _room.objects = room_update.objects;
                _room.generated = true;
            }
     
            //show_debug_message("Client: Room " + string(floor_id) + "," + string(room_id) + " objects recieved.");
            break;
    
        default:
            show_debug_message("Unknown event type: " + string(e_type));
            break;
    }
}