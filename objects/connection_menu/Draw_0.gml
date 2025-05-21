draw_set_color(c_white);
draw_set_halign(fa_left);



switch (menu_state) {
    case MenuState.MAIN:
        draw_text(b_host[0], b_host[1], "[ Host Game ]");
        draw_text(b_join[0], b_join[1], "[ Join Game ]");
        break;

    case MenuState.HOST:
	    draw_text(100, 40, "Your Public IP: " + local_ip);
		draw_text(b_port[0], b_port[1], "Port: " + port_input + (focused_field == "port" ? "|" : ""));
		draw_text(b_host_pass[0], b_host_pass[1], "Password: " + string_repeat("*", string_length(password_input)) + (focused_field == "password" ? "|" : ""));
		draw_text(b_start_host[0], b_start_host[1], "[ Start Hosting ]");
		draw_text(b_back[0], b_back[1], "[ Back ]");
	    break;


    case MenuState.JOIN:
        draw_text(b_ip[0], b_ip[1], "IP: " + ip_input + (focused_field == "ip" ? "|" : ""));
        draw_text(b_port[0], b_port[1], "Port: " + port_input + (focused_field == "port" ? "|" : ""));
        draw_text(b_pass[0], b_pass[1], "Password: " + string_repeat("*", string_length(password_input)) + (focused_field == "password" ? "|" : ""));
        draw_text(b_connect[0], b_connect[1], "[ Connect ]");
        draw_text(b_back[0], b_back[1], "[ Back ]");
        break;
}

draw_text(100, 320, status_message);