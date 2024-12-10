/// Client Networking Event

if (async_load[? "type"] == network_type_data) {
    var buffer = async_load[? "buffer"]; // Retrieve the buffer from async_load

    // Read the event type
    var e_type = buffer_read(buffer, buffer_u8);

    // Handle different event types
    switch (e_type) {
        
        // 1: Player Position Update
        case 1: 
            var p_id = buffer_read(buffer, buffer_u32);
            var p_x = buffer_read(buffer, buffer_f32);
            var p_y = buffer_read(buffer, buffer_f32);
            var room_id = buffer_read(buffer, buffer_u32);
            var facing = buffer_read(buffer, buffer_f32);

            // Update only if it's the local player
            if (p_id == global.local_player_id) {
                global.player.x = p_x;
                global.player.y = p_y;
                global.player.room_id = room_id;
                global.player.facing = facing;
            }
            break;

        // 2: House Map Data
		case 2:  // Event type 2: House map data
		    var house_map_json = buffer_read(buffer, buffer_string); 
		    global.house_map = json_parse(house_map_json); 

		    if (array_length(global.house_map) > 0 && array_length(global.house_map[0]) > 0) {
		        global.current_room = global.house_map[0][0];  // Correctly assign first room
		        show_debug_message("Client: Received and loaded house map.");
		    } else {
		        show_debug_message("Error: Received an empty or invalid house map.");
		    }
		    break;


        // 3: Lighting Update
        case 3:  // Lightning Trigger Event
            var lightning_triggered = buffer_read(buffer, buffer_bool);
            if (lightning_triggered) {
                global.weatherHandler.lighting_triggered = true;
                show_debug_message("Client: Lightning triggered locally.");
            }
            break;

        // Unknown Event Type
        default:
            show_debug_message("Unknown event type: " + string(e_type));
    }
}