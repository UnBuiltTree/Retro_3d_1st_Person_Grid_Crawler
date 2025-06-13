if(instance_number(obj_game) > 1){
	throw("obj_game is a singleton!")
}

draw_pattern = [];

instance_create_layer(0, 0, "Debug", obj_dungeon_generator);

tile_width = 64;
tile_tall  = 48;

offset_x = -global.MAP_OFFSET_X;
offset_y = -global.MAP_OFFSET_Y;

texd_surface_current	= -1;
texd_surface_from		= -1;
texd_surface_to			= -1;

player_x		= global.spawn_x;
player_y		= global.spawn_y;
player_real_x	= player_x;
player_real_y	= player_y;
global.player_x = player_x
global.player_y = player_y
player_angle	= 0;
global.player_angle = player_angle;
max_depth		= 24;
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
move_duration_base = 20;
move_delay			= 8;
move_cooldown		= 0;
move_cooldown_max	= 1;

move_progress	= 0;
move_start_x	= player_x;
move_start_y	= player_y;
move_target_x	= player_x;
move_target_y	= player_y;

function build_draw_pattern(radius) {
    for (var _layer = radius; _layer >= 1; _layer--) {
        for (var dy = -_layer; dy <= _layer; dy++) {
            var dx = _layer - abs(dy);
            array_push(draw_pattern, [ dx, dy ]);
            if (dx != 0) array_push(draw_pattern, [ -dx, dy ]);
        }
    }

    array_push(draw_pattern, [ 0, 0 ]);
}

global.draw_pattern = draw_pattern

build_draw_pattern(max_depth);

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
draw_clear_depth(1);

instance_create_layer(0, 0, "UILayer_1", obj_UI);
