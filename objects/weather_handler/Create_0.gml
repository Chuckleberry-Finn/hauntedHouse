// Initialize the lighting event variables
lighting_triggered = false;
flash_counter = 0;
sound_played = false
lerp_time = 0;  // Timer for controlling lerp duration
flash_duration = 50;  // Number of steps for each lerp (change for speed of transition)
previous_color = global.shadow_color;  // Store the original shadow color
previous_alpha = global.shadow_alpha

// Random time between 60 and 300 steps (1 to 5 seconds if FPS is 60)
alarm[0] = irandom_range(600, 1600);