/*
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    for (var i = array_length(gui_elements) - 1; i >= 0; i--) {
        var e = gui_elements[i];
        if (mx > e.e_x && mx < e.e_x + e.e_w && my > e.e_y && my < e.e_y + e.e_h) {
            dragging = i;
            drag_offset_x = mx - e.e_x;
            drag_offset_y = my - e.e_y;
            break;
        }
    }
}

if (mouse_check_button_released(mb_left)) {
    dragging = -1;
}

if (dragging != -1) {
    gui_elements[dragging].e_x = mx - drag_offset_x;
    gui_elements[dragging].e_y = my - drag_offset_y;
}
*/