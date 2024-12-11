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
            break;

        case 3:  // Lightning Update
            var lightning_triggered = buffer_read(buffer, buffer_bool);
            if (lightning_triggered) {
                global.weatherHandler.lighting_triggered = true;
                show_debug_message("Client: Lightning triggered.");
            }
            break;

        default:
            show_debug_message("Unknown event type: " + string(e_type));
            break;
    }
}