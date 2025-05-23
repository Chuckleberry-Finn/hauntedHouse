var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Focus input field
if (mouse_check_button_pressed(mb_left)) {
    if (menu_state == MenuState.JOIN) {
        if (point_in_rectangle(mx, my, b_ip[0], b_ip[1], b_ip[2], b_ip[3])) focused_field = "ip";
        else if (point_in_rectangle(mx, my, b_port[0], b_port[1], b_port[2], b_port[3])) focused_field = "port";
        else if (point_in_rectangle(mx, my, b_pass[0], b_pass[1], b_pass[2], b_pass[3])) focused_field = "password";
        else focused_field = "none";
    }
    if (menu_state == MenuState.HOST) {
        if (point_in_rectangle(mx, my, b_port[0], b_port[1], b_port[2], b_port[3])) focused_field = "port";
        else focused_field = "none";
    }
}



var keys = [
    vk_numpad0, vk_numpad1, vk_numpad2, vk_numpad3, vk_numpad4,
    vk_numpad5, vk_numpad6, vk_numpad7, vk_numpad8, vk_numpad9,
    ord("0"), ord("1"), ord("2"), ord("3"), ord("4"),
    ord("5"), ord("6"), ord("7"), ord("8"), ord("9"),
    ord("."), // for IP
    ord("A"), ord("Z") // if you want password support
];




// Numbers (top row and numpad)
for (var k = ord("0"); k <= ord("9"); k++) {
    if (keyboard_check_pressed(k)) {
        var ch = chr(k);
        if (focused_field == "ip") ip_input += ch;
        if (focused_field == "port") port_input += ch;
        if (focused_field == "password") password_input += ch;
    }
}

// Letters (for password)
for (var k = ord("A"); k <= ord("Z"); k++) {
    if (keyboard_check_pressed(k) && focused_field == "password") {
        password_input += chr(k);
    }
}

if ((keyboard_check_pressed(190) || keyboard_check_pressed(ord(".")) || keyboard_check_pressed(vk_decimal)) && focused_field == "ip") {
    ip_input += ".";
}



if (keyboard_check_pressed(vk_backspace)) {
    if (focused_field == "ip" && string_length(ip_input) > 0) {
        ip_input = string_delete(ip_input, string_length(ip_input), 1);
    }
    if (focused_field == "port" && string_length(port_input) > 0) {
        port_input = string_delete(port_input, string_length(port_input), 1);
    }
    if (focused_field == "password" && string_length(password_input) > 0) {
        password_input = string_delete(password_input, string_length(password_input), 1);
    }
}


switch (menu_state) {
    case MenuState.MAIN:
        if (mouse_check_button_pressed(mb_left)) {
            if (point_in_rectangle(mx, my, b_host[0], b_host[1], b_host[2], b_host[3])) menu_state = MenuState.HOST;
            if (point_in_rectangle(mx, my, b_join[0], b_join[1], b_join[2], b_join[3])) menu_state = MenuState.JOIN;
			if (point_in_rectangle(mx, my, b_quit[0], b_quit[1], b_quit[2], b_quit[3])) game_end();
        }
        break;

	case MenuState.HOST:
	
		if (copy_timer > 0) {
		    copy_timer -= 1;
		    if (copy_timer <= 0) status_message = "";
		}
	
	    if (mouse_check_button_pressed(mb_left)) {
	        if (point_in_rectangle(mx, my, b_start_host[0], b_start_host[1], b_start_host[2], b_start_host[3])) {
			    global.server_ip = ""; // Signals that this player is the host
			    global.next_port = real(port_input);
			    global.server_password = password_input;
			    room_goto(Room1);
			}

			if (point_in_rectangle(mx, my, b_ip[0], b_ip[1], b_ip[2], b_ip[3])) {
		        clipboard_set_text(local_ip); // <- Copy to clipboard
		        status_message = "IP copied to clipboard!";
				copy_timer = room_speed * 1.5;
		    }

	        if (point_in_rectangle(mx, my, b_back[0], b_back[1], b_back[2], b_back[3])) {
	            menu_state = MenuState.MAIN;
				status_message = "";
	        }
	    }
	    break;

    case MenuState.JOIN:
        if (mouse_check_button_pressed(mb_left)) {
            if (point_in_rectangle(mx, my, b_connect[0], b_connect[1], b_connect[2], b_connect[3])) {
			    if (string_length(ip_input) < 7 || string_pos(".", ip_input) <= 0) {
			        status_message = "Error: Invalid IP address.";
			    //} else if (!is_real(port_input) || real(port_input) <= 0) {
			    //    status_message = "Error: Invalid port: '" + port_input + "'";
			    } else {
			        global.server_ip = ip_input;
			        global.server_port = real(port_input);
			        global.server_password = password_input;
					status_message = "";
			        room_goto(Room1);
			    }
			}
            if (point_in_rectangle(mx, my, b_back[0], b_back[1], b_back[2], b_back[3])) {
                menu_state = MenuState.MAIN;
				status_message = "";
            }
        }
        break;
}
