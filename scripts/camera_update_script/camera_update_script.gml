function camera_update_script() {
	//Set up camera location
	
	var z_adjust = ((room_width + room_height)/20)
	
	var zz = -640-z_adjust
	
	//var xx = -300;
	//var yy = 400+(room_height*0.5);
	
	/*
	var xx = lengthdir_x(720,-current_time/20) + (room_width*0.5);//Rotation is negative now to match with the old gif and spin clockwise
	var yy = lengthdir_y(720,-current_time/20) + (room_height*0.5);
	*/
	var xx = lengthdir_x(820,-global.view_xy) + (room_width*0.5);
	var yy = lengthdir_y(820,-global.view_xy) + (room_height*0.5);

	//Build a matrix that looks from the camera location above, to the room center. The up vector points to -z
	//var mLookat = matrix_build_lookat(xx,yy,zz, o_person.x,o_person.y,50-z_adjust, 0,0,950);
	var mLookat = matrix_build_lookat(xx,yy,zz,(room_width*0.5),(room_width*0.5),50-z_adjust, 0,0,950);
	
	//Assign the matrix to the camera. This updates were the camera is looking from, without having to unnecessarily update the projection.
	camera_set_view_mat(view_camera[0], mLookat);

}
