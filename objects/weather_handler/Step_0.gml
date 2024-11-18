if (lighting_triggered) {

    lerp_time += 1;

    if (lerp_time <= flash_duration / 8 && !sound_played) {
        sound_played = true;
        audio_play_sound(snd_thunder, 1, false);
    }
    
    if (lerp_time <= flash_duration) {
        var r_ratio = color_get_red(previous_color) / 255;
        var g_ratio = color_get_green(previous_color) / 255;
        var b_ratio = color_get_blue(previous_color) / 255;
        
        master.shadow_color = make_color_rgb(
            lerp(color_get_red(previous_color), 255, lerp_time / flash_duration),
            lerp(color_get_green(previous_color), 255, lerp_time / flash_duration),
            lerp(color_get_blue(previous_color), 255, lerp_time / flash_duration)
        );
        master.shadow_alpha = lerp(previous_alpha, 0, lerp_time / flash_duration);
    }
    
    else if (lerp_time <= flash_duration * 2) {
        master.shadow_color = make_color_rgb(
            lerp(255, color_get_red(previous_color), (lerp_time - flash_duration) / flash_duration),
            lerp(255, color_get_green(previous_color), (lerp_time - flash_duration) / flash_duration),
            lerp(255, color_get_blue(previous_color), (lerp_time - flash_duration) / flash_duration)
        );
        master.shadow_alpha = lerp(0, previous_alpha, (lerp_time - flash_duration) / flash_duration);
    } 
    
    else {
        master.shadow_alpha = previous_alpha;
        master.shadow_color = previous_color;
        lighting_triggered = false;
        lerp_time = 0;
        sound_played = false;
    }
}