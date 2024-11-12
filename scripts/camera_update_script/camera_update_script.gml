function camera_update_script() {
	
	var z_adjust = ((room_width + room_height)/20)
	var zz = -640-z_adjust
	var xx = lengthdir_x(820,-global.view_xy) + (room_width*0.5);
	var yy = lengthdir_y(820,-global.view_xy) + (room_height*0.5);
	var mLookat = matrix_build_lookat(xx,yy,zz,(room_width*0.5),(room_width*0.5),50-z_adjust, 0,0,950);
	
	camera_set_view_mat(view_camera[0], mLookat);
}
