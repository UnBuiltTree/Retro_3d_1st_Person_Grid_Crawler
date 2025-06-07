if (!variable_global_exists("tile_definitions") || !ds_exists(global.tile_definitions, ds_type_map)) {
    global.tile_definitions = ds_map_create();
}

// Generate dungeon
instance_create_layer(0, 0, "Instances", obj_dungeon_generator);

texd_surface_current	= -1;
texd_surface_from		= -1;
texd_surface_to			= -1;

player_x		= global.spawn_x;
player_y		= global.spawn_y;
player_real_x	= player_x;
player_real_y	= player_y;
player_facing	= 0;  // facing North
max_depth		= 7;

dx	= [0, 1, 0, -1];
dy	= [-1, 0, 1, 0];

turn_speed			= 0.75;
turn_delay			= 8;
turning				= false;
turn_progress		= 0;
turn_direction		= 0;
turn_target_facing	= player_facing;

moving			= false;
move_progress	= 0;
move_delay		= 8;
move_cooldown	= 0;
move_start_x	= player_real_x;
move_start_y	= player_real_y;
move_target_x	= player_real_x;
move_target_y	= player_real_y;

text_toggle = true;
db_view_toggle = true;

