/// Client Handler Create Event

// Initialize global variables
global.server_socket = -1;  // Set as unconnected by default
global.is_connected = false;

// Connect to the server (replace IP and port)
var server_ip = "127.0.0.1";  // Change this for LAN/online testing
var port = 51234;

if (global.server_socket != -1) {
    global.is_connected = true;
	
	// Request the house map from the server
    var buffer = buffer_create(256, buffer_grow, 1);
    buffer_write(buffer, buffer_u8, 2);
    network_send_raw(global.server_socket, buffer, buffer_tell(buffer));
    buffer_delete(buffer);

    show_debug_message("Connected to the server!");
	
} else {
    show_debug_message("Failed to connect to the server.");
}
