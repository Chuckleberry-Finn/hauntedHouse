// Check if the middle mouse button (mouse wheel) is being held down
if (mouse_check_button(mb_middle)) {
    // If this is the first frame the button is pressed, initialize dragging
    if (!mouse_dragging) {
        mouse_dragging = true;
        last_mouse_x = display_mouse_get_x();
    } else {
        // Calculate the change in mouse position
        var current_mouse_x = display_mouse_get_x();
        var delta_x = current_mouse_x - last_mouse_x;
        
        global.view_xy += delta_x * 0.2; // Adjust the multiplier for sensitivity
        
        // Update the last mouse position if movement was significant
        last_mouse_x = current_mouse_x;
    }
} else {
    // Reset dragging state when the middle mouse button is released
    mouse_dragging = false;
}