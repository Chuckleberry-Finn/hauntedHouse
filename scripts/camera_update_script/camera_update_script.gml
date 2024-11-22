function camera_update_script() {
    var room_diagonal = sqrt(sqr(room_width) + sqr(room_height));
    var z_adjust = (room_diagonal / 20);
    var camera_radius = room_diagonal*0.7;
    var zz = -800 - z_adjust;
    var xx = (room_width * 0.5) + lengthdir_x(camera_radius, -global.view_xy);
    var yy = (room_height * 0.5) + lengthdir_y(camera_radius, -global.view_xy);
    var mLookat = matrix_build_lookat(xx, yy, zz, (room_width * 0.5), (room_height * 0.5), 50 - z_adjust, 0, 0, 950);

    camera_set_view_mat(view_camera[0], mLookat);
}