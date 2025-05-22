draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


function draw_UI_button(bbox, text) {
    draw_rectangle(bbox[0]-2, bbox[1]-2, bbox[2]+2, bbox[3]+2, true);
    var bw = bbox[2] - bbox[0];
    var bh = bbox[3] - bbox[1];
    draw_text(
        bbox[0] + (bw - string_width(text)) / 2,
        bbox[1] + (bh - string_height(text)) / 2,
        text
    );
}

switch (menu_state) {
    case MenuState.MAIN:
		draw_set_color(c_white);
		
		draw_UI_button(b_host, "Host Game")
		draw_UI_button(b_join, "Join Game")

        break;

    case MenuState.HOST:
		draw_set_color(c_white);
		
		draw_rectangle(b_ip[0] - 2, b_ip[1] - 2, b_ip[2] + string_width(local_ip) + 2, b_ip[3] + 2, true);
		draw_text(b_ip[0], b_ip[1], "Your Public IP: " + local_ip);
		
		draw_rectangle(b_port[0] - 2, b_port[1] - 2, b_port[2] + 2, b_port[3] + 2, true);
		draw_text(b_port[0], b_port[1], "Port: " + port_input + (focused_field == "port" ? "|" : ""));
		
		draw_rectangle(b_host_pass[0] - 2, b_host_pass[1] - 2, b_host_pass[2] + 2, b_host_pass[3] + 2, true);
		draw_text(b_host_pass[0], b_host_pass[1], "Password: " + string_repeat("*", string_length(password_input)) + (focused_field == "password" ? "|" : ""));
		
		draw_UI_button(b_start_host, "Start Hosting")
		draw_UI_button(b_back, "Back")
		
	    break;


    case MenuState.JOIN:
		draw_set_color(c_white);
		draw_rectangle(b_ip[0] - 2, b_ip[1] - 2, b_ip[2] + 2, b_ip[3] + 2, true);
        draw_text(b_ip[0], b_ip[1], "IP: " + ip_input + (focused_field == "ip" ? "|" : ""));
		
		draw_rectangle(b_port[0] - 2, b_port[1] - 2, b_port[2] + 2, b_port[3] + 2, true);
        draw_text(b_port[0], b_port[1], "Port: " + port_input + (focused_field == "port" ? "|" : ""));
		
		draw_rectangle(b_pass[0] - 2, b_pass[1] - 2, b_pass[2] + 2, b_pass[3] + 2, true);
        draw_text(b_pass[0], b_pass[1], "Password: " + string_repeat("*", string_length(password_input)) + (focused_field == "password" ? "|" : ""));
		
		draw_UI_button(b_connect, "Connect")
		draw_UI_button(b_back, "Back")
		
        break;
}

draw_text(100, 320, status_message);