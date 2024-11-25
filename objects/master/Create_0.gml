gpu_set_alphatestenable(true);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_counterclockwise);

audio_play_sound(snd_ambience, 1, true);
sound_current = noone;

shadow_color = make_color_rgb(10, 5, 15)
shadow_alpha = 0.8
global.weatherHandler = instance_create_depth(-1,-1,-1, weather_handler)

global.view_xy = 45

mouse_dragging = false; // Tracks whether the middle mouse button is being held down
last_mouse_x = 0; // Stores the last recorded mouse x position

view_enabled = true;
view_set_visible(0, true);

camera = camera_create();

projMat = matrix_build_projection_perspective_fov(60, view_get_wport(0) / view_get_hport(0), 32, 32000);
camera_set_proj_mat(camera, projMat);

view_set_camera(0, camera);

camera_set_update_script(view_camera[0], camera_update_script);

instance_create_depth(-1,-1,-1, obj_debug)

global.player = instance_create_depth(room_width/2,50,0, o_person)

grid_size = 20;
max_rooms = 150;
num_floors = 3;

global.topWall = instance_create_depth(-1,-1,-1, plane_builder, {draw : "north",})
global.the_floor = instance_create_depth(-1,-1,-1, plane_builder, {draw : "the_floor", r_h : room_height})
global.rightWall = instance_create_depth(-1,-1,-1, plane_builder, {draw : "east",})
global.leftWall = instance_create_depth(-1,-1,-1, plane_builder, {draw : "west",})
global.bottomWall = instance_create_depth(-1,-1,-1, plane_builder, {draw : "south",})

global.current_room = false
global.current_room_objs = []

global.houseHandler = instance_create_depth(-1,-1,-1, house_handler)
global.house_map = global.houseHandler.generate_house_map(max_rooms, num_floors);

show_debug_message("Generated House Map: ", array_length(global.house_map) )

global.houseHandler.enter_room("north", 0)

global.lights = []
global.num_lights = 0
global.darkness_surface = surface_create(room_width, room_height);

// Add a new light source to the global lights array
global.num_lights += 1;
global.lights[global.num_lights - 1] = instance_create_depth(room_width/2, room_height/2, -5, obj_light, {range : 400, light_color : make_color_rgb(255, 230, 190)});