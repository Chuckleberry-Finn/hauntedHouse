audio_play_sound(snd_ambience, 1, true);

enum MenuState { MAIN, HOST, JOIN }
menu_state = MenuState.MAIN;

copy_timer = 0;

ip_input = "";
port_input = "54321";
password_input = "";

focused_field = "none";
key_input_delay = 0;
key_input_max_delay = 6;

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
b_quit = [100, 250, 300, 280];
