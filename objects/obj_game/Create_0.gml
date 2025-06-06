
tile_definitions = ds_map_create();

// “floor1” entry
var floor_map = ds_map_create();
ds_map_add(floor_map, "sprite", spr_floor);
ds_map_add(floor_map, "is_wall", false);
ds_map_add(tile_definitions, "floor1", floor_map);

// “wall1” entry
var wall_map = ds_map_create();
ds_map_add(wall_map, "sprite", spr_wall);
ds_map_add(wall_map, "is_wall", true);
ds_map_add(tile_definitions, "wall1", wall_map);


texd_surface_current = -1;

max_depth            = 7;

move_cooldown        = 0;

dx = [0, 1, 0, -1];		// North, East, South, West
dy = [-1, 0, 1, 0];

player_x		= 2.0;
player_y		= 2.0;
player_facing	= 0;

player_real_x	= player_x;
player_real_y	= player_y;

turn_speed		= 0.5;
moving			= false;
move_progress	= 0;
move_delay		= 8;

turn_speed		= 0.75;
turning			= false;
turn_progress	= 0;
turn_delay		= 8;
player_angle	= 0;
turn_direction	= 0;

move_start_x	= player_real_x;
move_start_y	= player_real_y;
move_target_x	= player_real_x;
move_target_y	= player_real_y;

turn_target_facing	= player_facing;

texd_surface_from	= -1;
texd_surface_to		= -1;

// Grid Map Creation

var map_array = [
    [1,1,1,1,1,1,1],
    [1,0,0,0,1,0,1],
    [1,0,0,0,0,0,1],
    [1,0,0,0,1,0,1],
    [1,1,0,1,1,0,1],
    [1,0,0,0,1,0,1],
    [1,0,1,0,1,0,1],
    [1,0,0,0,0,0,1],
    [1,1,1,1,1,1,1]
];

var map_w = array_length(map_array[0]);
var map_h = array_length(map_array);

global.map_grid = ds_grid_create(map_w, map_h);

// Fill the DS grid with the corresponding string keys
for (var _y = 0; _y < map_h; _y++) {
    for (var _x = 0; _x < map_w; _x++) {
        var val = map_array[_y][_x];
        if (val == 0) {
            ds_grid_set(global.map_grid, _x, _y, "floor1");
        } else {
            ds_grid_set(global.map_grid, _x, _y, "wall1");
        }
    }
}

// Clear the temp map array
global.map_array = undefined;