/// Client Handler Networking Event

if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"];
    var e_type = buffer_read(buffer, buffer_u8);  // First byte is the event type

    switch (e_type) {
        case 1:  // Player Position Update
            var p_id = buffer_read(buffer, buffer_u32);
            var p_x = buffer_read(buffer, buffer_f32);
            var p_y = buffer_read(buffer, buffer_f32);
            var room_id = buffer_read(buffer, buffer_u32);
            var facing = buffer_read(buffer, buffer_f32);
            show_debug_message("Received Position Update: Player " + string(p_id));
            break;

        case 2:  // House Map Data
            var house_map_json = buffer_read(buffer, buffer_string); 
            global.house_map = json_parse(house_map_json); 
            show_debug_message("Client: Received house map.");
			
			if !global.player {
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

            // Direct Room Update Using floor_id
            var floor_id = room_update.floor_id;
            var room_id = room_update.room_id;
            var _room = global.house_map[floor_id][room_id];

            if (_room.room_id == room_id) {
                _room.objects = room_update.objects;
                _room.generated = true;  // Mark room as generated
            }
     
            show_debug_message("Client: Room " + string(floor_id) + "," + string(room_id) + " objects recieved.");
            break;
    
        default:
            show_debug_message("Unknown event type: " + string(e_type));
            break;
    }
}