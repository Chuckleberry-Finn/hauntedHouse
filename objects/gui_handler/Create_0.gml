gui_elements = []; // Array of all elements
dragging = -1;      // Index of the dragged element
drag_offset_x = 0;
drag_offset_y = 0;

function gui_element_create(_id, _x, _y, _w, _h, _sprite, _data) {
    
	var element = {
        e_id: _id,
        e_x: _x,
        e_y: _y,
        e_w: _w,
        e_h: _h,
		e_sprite: _sprite,
        e_data: _data
    };
	
	array_push(gui_elements, element);
	
	return element
}



function createStatsUI(){
	//_id, _x, _y, _w, _h, _data

	var gui_wh = 64;
	var sb_offset = 0; // track vertical offset
	var stats = global.statsHandler.stats;

	show_debug_message(typeof(stats));

	// Loop over keys in the stats struct
	var keys = variable_struct_get_names(stats);
	for (var i = 0; i < array_length(keys); i++) {
		var key = keys[i]; // e.g., "sanity"
		var value = variable_instance_get(stats, key);

		// Build asset name (assumes stat_sanity, stat_smarts, etc. are defined sprites)
		var sprite_name = asset_get_index("stat_" + key);

		gui_element_create(
			"stat_" + key,
			32,
			32 + (sb_offset * (gui_wh + 4)),
			gui_wh,
			gui_wh,
			sprite_name,
			key
		);
		sb_offset++;
	}
}



function draw(element) {

	draw_set_color(c_white);

	if (!is_undefined(element.e_sprite)) {
		draw_sprite_ext(
	            element.e_sprite,
	            0,
	            element.e_x,
	            element.e_y,
	            1,
	            1,
	            0,
	            c_white,
	            1
	        );
	}

	draw_set_font(stat_font);
	
	var s_data = variable_instance_get(global.statsHandler.stats, string(element.e_data))

	var sd_w = string_width(s_data)
	var sd_h = string_height(s_data)
	
	draw_text(element.e_x + element.e_w + (sd_w/2), element.e_y + ((element.e_h-sd_h)/2), string(s_data));
}
