global.is_connected = false;
// Create a socket

var server_ip = "127.0.0.1";  // Change this for LAN/online testing
var port = 12345;

if (global.server_socket != -1) {
    global.is_connected = true;
	
	/*
	show_debug_message("request map for socket:" + string(global.server_socket))
	
	// Request? the house map from the server
    var buffer = buffer_create(256, buffer_grow, 1);
    buffer_write(buffer, buffer_u8, 1);
    network_send_packet(global.server_socket, buffer, buffer_tell(buffer));
    buffer_delete(buffer);
	*/
	
    show_debug_message("Connected to the server!");
	
} else {
    show_debug_message("Failed to connect to the server.");
}