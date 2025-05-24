gpu_set_alphatestenable(true);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_counterclockwise);

//audio_play_sound(snd_ambience, 1, true);

sound_current = noone;

global.shadow_color = make_color_rgb(10, 5, 15);
global.shadow_alpha = 0.8;

global.view_xy = 45;

mouse_dragging = false; // Tracks whether the middle mouse button is being held down
last_mouse_x = 0; // Stores the last recorded mouse x position

view_enabled = true;
view_set_visible(0, true);

camera = camera_create();

projMat = matrix_build_projection_perspective_fov(60, view_get_wport(0) / view_get_hport(0), 32, 32000);
camera_set_proj_mat(camera, projMat);

view_set_camera(0, camera);

camera_set_update_script(view_camera[0], camera_update_script);

instance_create_depth(-1, -1, -1, obj_debug);

global.grid_size = 20;
global.max_rooms = 150;
global.num_floors = 3;

global.topWall = instance_create_depth(-1, -1, -1, plane_builder, {draw: "north"});
global.the_floor = instance_create_depth(-1, -1, -1, plane_builder, {draw: "the_floor", r_h: room_height});
global.rightWall = instance_create_depth(-1, -1, -1, plane_builder, {draw: "east"});
global.leftWall = instance_create_depth(-1, -1, -1, plane_builder, {draw: "west"});
global.bottomWall = instance_create_depth(-1, -1, -1, plane_builder, {draw: "south"});

global.current_room = false;
global.current_room_objs = [];

global.lights = [];
global.num_lights = 0;
global.darkness_surface = surface_create(room_width, room_height);

global.is_server = false


global.client_socket_id = -1
global.players = [];
global.other_players = [];

global.houseHandler = instance_create_depth(-1, -1, -1, house_handler);
global.house_map = []

global.player = undefined

global.weatherHandler = instance_create_depth(-1, -1, -1, weather_handler);


// The menu already set these:
if (global.server_ip != "") {
    // Client
	global.is_server = false;
	show_debug_message("Client: Attempting to Connect to " + global.server_ip + ":" + string(global.server_port));
    global.client_handler = instance_create_layer(0, 0, "Instances", client_handler);
    

} else {
    // Host
    global.is_server = true;
	show_debug_message("Server: Attempting to Host on port " + string(global.server_port));
    global.server_handler = instance_create_layer(0, 0, "Instances", server_handler);
}


// Add a new light source to the global lights array
global.num_lights += 1;
global.lights[global.num_lights - 1] = instance_create_depth(
    room_width / 2, 
    room_height / 2, 
    -5, 
    obj_light, 
    {range: 400, light_color: make_color_rgb(255, 230, 190)}
);
