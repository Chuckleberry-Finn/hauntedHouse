global.is_connected = false;


var socket = network_create_socket(network_socket_tcp);
global.server_socket = network_connect_async(socket, global.server_ip, global.server_port);


if (global.server_socket != -1) {
    show_debug_message("Client connected to server at socket:" + string(global.server_socket) + ", " + global.server_ip + ":" + string(global.server_port));
} else {
    show_debug_message("Failed to connect to server at socket:"  + string(global.server_socket) + ", " + global.server_ip + ":" + string(global.server_port));
}
