if (!variable_global_exists("tile_definitions") || !ds_exists(global.tile_definitions, ds_type_map)) {
    global.tile_definitions = ds_map_create();
}

// 360 × 240 UI buffer
ui_surf = surface_create(360, 240);
if (surface_exists(ui_surf)) {
    var ui_tex = surface_get_texture(ui_surf);
}

instance_create_layer(0, 0, "Instances", obj_dungeon_generator);

tile_width = 64;
tile_tall  = 32;
grid_w     = ds_grid_width(global.main_grid);
grid_h     = ds_grid_height(global.main_grid);

offset_x = -global.MAP_OFFSET_X;
offset_y = -global.MAP_OFFSET_Y;

tile_size				= 32;
texd_surface_current	= -1;
texd_surface_from		= -1;
texd_surface_to			= -1;

player_x		= global.spawn_x;
player_y		= global.spawn_y;
player_real_x	= player_x;
player_real_y	= player_y;
player_angle	= 0;
max_depth		= 7;
look_dist = (tile_width*max_depth*2)

dx	= [0, 1, 0, -1];
dy	= [-1, 0, 1, 0];

turning			= false;
turn_progress	= 0;
turn_duration	= 20;
turn_from_angle	= 0;
turn_to_angle	= 0;

moving				= false;
move_duration		= 20;
move_delay			= 8;
move_cooldown		= 0;
move_cooldown_max	= 10;

move_progress	= 0;
move_start_x	= player_x;
move_start_y	= player_y;
move_target_x	= player_x;
move_target_y	= player_y;

text_toggle = true;
db_view_toggle = true;

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
draw_clear_depth(1);
