function adjacent_tiles(_gx, _gy){
	return {
		top    : global.main_grid[# _gx  , _gy-1],
		bottom : global.main_grid[# _gx  , _gy+1],
		left   : global.main_grid[# _gx-1, _gy  ],
		right  : global.main_grid[# _gx+1, _gy  ],
	}
}

function adjacent_tiles_8(_gx, _gy) {
	return {
		top_left     : global.main_grid[# _gx-1, _gy-1],
		top          : global.main_grid[# _gx  , _gy-1],
		top_right    : global.main_grid[# _gx+1, _gy-1],
		left         : global.main_grid[# _gx-1, _gy  ],
		// center
		right        : global.main_grid[# _gx+1, _gy  ],
		bottom_left  : global.main_grid[# _gx-1, _gy+1],
		bottom       : global.main_grid[# _gx  , _gy+1],
		bottom_right : global.main_grid[# _gx+1, _gy+1],
	};
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

function check_adjacent_for_opposing(_x, _y, _tile) {
	if (_x <= 0 || _x >= grid_size - 1 || _y <= 0 || _y >= grid_size - 1) {
		return false;
	}

	var neighbors = adjacent_tiles(_x, _y);

	var top_match    = (neighbors.top    == _tile);
	var bottom_match = (neighbors.bottom == _tile);
	var left_match   = (neighbors.left   == _tile);
	var right_match  = (neighbors.right  == _tile);

	var match_count = top_match + bottom_match + left_match + right_match;

	if (match_count == 2) {
		if ((top_match && bottom_match) || (left_match && right_match)) {
			return true;
		}
	}

	return false;
}


function create_tile(name_str, properties) {
    var const_name = "TILE_" + string_upper(name_str);
    variable_global_set(const_name, name_str);

    // Add to tile definitions map
    ds_map_set(global.tile_definitions, name_str, properties);
}
