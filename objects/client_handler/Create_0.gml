global.is_connected = false;

var socket = network_create_socket(network_socket_tcp);
global.server_socket = network_connect_async(socket, global.server_ip, global.server_port);