

// player world center point position
var wcx = player_real_x * tile_width + tile_width * 0.5;
var wcy = player_real_y * tile_width + tile_width * 0.5;
var wcz = 0;

// facing
var rad = degtorad(player_angle - 90);

var dx_cam =  sin(rad) * tile_width;
var dy_cam =  cos(rad) * tile_width;

// camera center point position
var cam_x = wcx;
var cam_y = wcy;
var cam_z = wcz + tile_tall * 0.5;

// camera look at target point
var look_x = wcx - dx_cam;
var look_y = wcy - dy_cam;
var look_z = wcz + tile_tall * 0.5;

var cam  = camera_get_active();
var view = matrix_build_lookat(
    cam_x, cam_y, cam_z,
    look_x, look_y, look_z,
    0,      0,      1
);
var proj = matrix_build_projection_perspective_fov(
    45,
    display_get_width() / display_get_height(),
    1,
    look_dist
);
camera_set_view_mat(cam, view);
camera_set_proj_mat(cam, proj);
camera_apply(cam);

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
draw_clear_depth(1);

// draw the dungeon
draw_dungeon();

matrix_set(matrix_world, matrix_build_identity());
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
