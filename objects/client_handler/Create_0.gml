global.is_connected = false;

var server_ip = "127.0.0.1";  // Change this for LAN/online testing
var port = 12345;

// Create socket and attempt connection using global IP/port
var socket = network_create_socket(network_socket_tcp);
global.server_socket = network_connect(socket, global.server_ip, global.server_port);

if (global.server_socket != -1) {
    show_debug_message("Client connected to server at " + global.server_ip + ":" + string(global.server_port));
} else {
    show_debug_message("Failed to connect to server at " + global.server_ip + ":" + string(global.server_port));
	room_goto(r_connection_menu);
}