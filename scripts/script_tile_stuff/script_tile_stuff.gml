// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function adjacent_tiles(_gx, _gy){
	return {
		top    : global.main_grid[# _gx  , _gy-1],
		bottom : global.main_grid[# _gx  , _gy+1],
		left   : global.main_grid[# _gx-1, _gy  ],
		right  : global.main_grid[# _gx+1, _gy  ],
	}
}

function adjacent_tiles_8(_gx, _gy){
	return {
		top_left	: global.main_grid[# _gx-1, _gy-1],
		top			: global.main_grid[# _gx  , _gy-1],
		top_right	: global.main_grid[# _gx+1, _gy-1],
		left		: global.main_grid[# _gx-1, _gy  ],
		right		: global.main_grid[# _gx+1, _gy  ],
		top_left	: global.main_grid[# _gx-1, _gy+1],
		bottom		: global.main_grid[# _gx  , _gy+1],
		top_right	: global.main_grid[# _gx+1, _gy+1],
	}
}

function check_adjacent_for(_x, _y, _tile){
	var neighbors = adjacent_tiles(_x, _y);
	var has_room_neighbor = 0;

		if (_x > 0 && _x < grid_size-1 && _y > 0 && _y < grid_size-1) {
			if (
				neighbors.top == _tile ||
				neighbors.bottom == _tile ||
				neighbors.left == _tile ||
				neighbors.right == _tile
			) {
				has_room_neighbor = true;
			}
		} else {
			return -1
		}
	return 1
}

// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_tile(name_str, properties) {
    var const_name = "TILE_" + string_upper(name_str);
    variable_global_set(const_name, name_str);

    // Add to tile definitions map
    ds_map_set(global.tile_definitions, name_str, properties);
}