// Update the angle to make the object move around the circle
angle += rotation_speed;

// Keep the angle within 0-360 degrees
if (angle >= 360) angle -= 360;



// Calculate the change in position based on the angle and radius
var move_x = cos(degtorad(angle)) * radius;
var move_y = sin(degtorad(angle)) * radius;

x = center_x+move_x;
y = center_y+move_y;