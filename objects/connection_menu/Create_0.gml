enum MenuState { MAIN, HOST, JOIN }
menu_state = MenuState.MAIN;

ip_input = "";
port_input = "5000";
password_input = "";

focused_field = "none";

status_message = "Fetching public IP...";
local_ip = "Fetching...";

request_id_ip = http_get("https://api.ipify.org");

// Button regions
b_host = [100, 100, 300, 130];
b_join = [100, 150, 300, 180];
b_start_host = [100, 200, 300, 230];
b_connect = [100, 200, 300, 230];
b_back = [100, 250, 300, 280];
b_ip = [100, 60, 300, 80];
b_port = [100, 100, 300, 120];
b_pass = [100, 140, 300, 160];
b_host_pass = [100, 140, 300, 160];
