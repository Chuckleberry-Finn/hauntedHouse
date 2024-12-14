global.is_connected = false;

var server_ip = "127.0.0.1";  // Change this for LAN/online testing
var port = 12345;

if (global.server_socket != -1) {
    global.is_connected = true;
    show_debug_message("Connected to the server!");
	
} else {
    show_debug_message("Failed to connect to the server.");
}