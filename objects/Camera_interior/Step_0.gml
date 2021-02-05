/// @desc

//camX = clamp(follow.x,x_min,x_max);
//camY = clamp(follow.y,y_min,y_max);

camX = follow.x;
camY = follow.y;

x += (xTo - x) / follow_speed;
y += (yTo - y) / follow_speed;

if(follow != noone){
	//xTo = clamp(follow.x,x_min,x_max);
	//yTo = clamp(follow.y,y_min,y_max);
	xTo = follow.x;
	yTo = follow.y;
}

var vm = matrix_build_lookat(x,y,-10,x,y,0,0,1,0);
camera_set_view_mat(camera_1,vm);
