function create_connection(grid_, room1, room2) {
    var grid_w = ds_grid_width(grid_)
    var grid_h = ds_grid_height(grid_)

    // Room 1 bounds
	var bounds1 = room1.get_bounds()
	var bounds2 = room2.get_bounds()

	var _x1 = room1.x
	var _y1 = room1.y
	var _x2 = room2.x
	var _y2 = room2.y

    // Check for vertical straight connections (shared X, exclude edges)
    var _min_shared_x = max(bounds1.left, bounds2.left);
    var _max_shared_x = min(bounds1.right, bounds2.right);
    if (_min_shared_x <= _max_shared_x) {
        var _valid_x_list = [];
        for (var _x = _min_shared_x; _x <= _max_shared_x; _x++) {
            if (
                _x != bounds1.left && _x != bounds1.right &&
                _x != bounds2.left && _x != bounds2.right
            ) {
                array_push(_valid_x_list, _x);
            }
        }

        if (array_length(_valid_x_list) > 0) {
            var _shared_x = _valid_x_list[irandom(array_length(_valid_x_list) - 1)];
            for (var _y = min(_y1, _y2); _y <= max(_y1, _y2); _y++) {
				if  grid_[# _shared_x, _y] == global.TILE_WALL {
					carve_tile(grid_, _shared_x, _y);
					if is_perimeter(grid_, room1, _shared_x, _y) {
						grid_[# _shared_x, _y] = global.TILE_DOOR;
					} else if is_perimeter(grid_, room2, _shared_x, _y) {
						grid_[# _shared_x, _y] = global.TILE_DOOR;
					}
				}
            }
            return;
        }
    }

    // Check for horizontal straight connections (shared Y, exclude edges)
    var _min_shared_y = max(bounds1.top, bounds2.top);
    var _max_shared_y = min(bounds1.bottom, bounds2.bottom);
    if (_min_shared_y <= _max_shared_y) {
        var _valid_y_list = [];
        for (var _y = _min_shared_y; _y <= _max_shared_y; _y++) {
            if (
                _y != bounds1.top && _y != bounds1.bottom &&
                _y != bounds2.top && _y != bounds2.bottom
            ) {
                array_push(_valid_y_list, _y);
            }
        }

        if (array_length(_valid_y_list) > 0) {
            var _shared_y = _valid_y_list[irandom(array_length(_valid_y_list) - 1)];
            for (var _x = min(_x1, _x2); _x <= max(_x1, _x2); _x++) {
				if  grid_[# _x, _shared_y] == global.TILE_WALL {
					carve_tile(grid_, _x, _shared_y);
					
					if is_perimeter(grid_, room1, _x, _shared_y) {
						grid_[# _x, _shared_y] = global.TILE_DOOR;
					} else if is_perimeter(grid_, room2, _x, _shared_y) {
						grid_[# _x, _shared_y] = global.TILE_DOOR;
					}
				} else {
					carve_tile(grid_, _x, _shared_y);
				}
            }
            return;
        }
    }

    // Fall back to double bend
    var _dx = abs(_x2 - _x1);
    var _dy = abs(_y2 - _y1);
    var _use_horizontal_first = _dx > _dy ? true : (_dy > _dx ? false : choose(true, false));

    if (_use_horizontal_first) {
        var _mid_x = _x1 + sign(_x2 - _x1) * floor(_dx / 2);
        for (var _x = min(_x1, _mid_x); _x <= max(_x1, _mid_x); _x++) {
            carve_tile(grid_, _x, _y1);
        }
        for (var _y = min(_y1, _y2); _y <= max(_y1, _y2); _y++) {
            carve_tile(grid_, _mid_x, _y);
        }
        for (var _x = min(_mid_x, _x2); _x <= max(_mid_x, _x2); _x++) {
            carve_tile(grid_, _x, _y2);
        }
    } else {
        var _mid_y = _y1 + sign(_y2 - _y1) * floor(_dy / 2);
        for (var _y = min(_y1, _mid_y); _y <= max(_y1, _mid_y); _y++) {
            carve_tile(grid_, _x1, _y);
        }
        for (var _x = min(_x1, _x2); _x <= max(_x1, _x2); _x++) {
            carve_tile(grid_, _x, _mid_y);
        }
        for (var _y = min(_mid_y, _y2); _y <= max(_mid_y, _y2); _y++) {
            carve_tile(grid_, _x2, _y);
        }
    }
}


function carve_tile(grid_, _x, _y) {

    if (_x >= 0 && _x < grid_size && _y >= 0 && _y < grid_size) {
		if check_adjacent_for(_x, _y, global.TILE_VOID) == -1 {
			grid_[# _x, _y] = global.TILE_WALL;
		} else {
			grid_[# _x, _y] = global.TILE_ROOM;
		}

        for (var dx = -1; dx <= 1; dx++) {
            for (var dy = -1; dy <= 1; dy++) {
                var _nx = _x + dx;
                var _ny = _y + dy;

                if ((dx != 0 || dy != 0) && _nx >= 0 && _nx < grid_size && _ny >= 0 && _ny < grid_size) {
                    if (grid_[# _nx, _ny] != global.TILE_ROOM) and (grid_[# _nx, _ny] != global.TILE_DOOR) {
                        grid_[# _nx, _ny] = global.TILE_WALL;
                    }
                }
            }
        }
    }
}

function connect_rooms(room_list, room_id1, room_id2) {
    var room1 = ds_list_find_value(room_list, room_id1);
    var room2 = ds_list_find_value(room_list, room_id2);

    if (room1 == undefined || room2 == undefined) {
        show_debug_message("Error: connect_rooms - invalid room IDs");
        return;
    }
	ds_list_add(room1.connected_rooms, room2.id)
	ds_list_add(room2.connected_rooms, room1.id)
}

function render_room(grid_, _room_map) {
	var bounds = _room_map.get_bounds()

    for (var yy = 0; yy <  _room_map.height; yy++) {
        for (var xx = 0; xx < _room_map.width; xx++) {
            var cx = bounds.left + xx;
            var cy = bounds.top + yy;
            if (cx >= 0 && cx < grid_size && cy >= 0 && cy < grid_size) {
                // Perimeter → WALL unless it's already a DOOR
                if (xx == 0 || xx == _room_map.width-1 || yy == 0 || yy ==  _room_map.height-1) {
                    if (grid_[# cx, cy] != global.TILE_DOOR) {
                        grid_[# cx, cy] = global.TILE_WALL;
                    }
                } else {
                    // Interior → ROOM (floor)
                    grid_[# cx, cy] = global.TILE_ROOM;
                }
            }
        }
    }
}

function render_room_blob(grid_, _room_map) {
    var _w = _room_map.width + 1
    var _h = _room_map.height + 1
	var new_room = new struct_room(-1, _room_map.x, _room_map.y, _w, _h)
	var bounds = new_room.get_bounds()
	new_room.clear()
	delete new_room

    var grid_w = ds_grid_width(grid_)
    var grid_h = ds_grid_height(grid_)

    var _target_tiles = irandom_range(floor((_w * _h) * 0.6), floor((_w * _h) * 0.8));

    var _blob = ds_grid_create(_w, _h);
    ds_grid_set_region(_blob, 0, 0, _w, _h, 0);

    var _open = ds_list_create();
    var _cx = floor(_w / 2);
    var _cy = floor(_h / 2);
    ds_list_add(_open, [_cx, _cy]);

    var _filled = 0;

    while (_filled < _target_tiles && ds_list_size(_open) > 0) {
        var _idx = irandom(ds_list_size(_open) - 1);
        var _pick = ds_list_find_value(_open, _idx);
        ds_list_delete(_open, _idx);

        var _x = _pick[0];
        var _y = _pick[1];

        if (_x < 0 || _x >= _w || _y < 0 || _y >= _h) continue;
        if (_blob[# _x, _y] == 1) continue;

        _blob[# _x, _y] = 1;
        _filled++;

        var _neighbors = [
            [_x - 1, _y],
            [_x + 1, _y],
            [_x, _y - 1],
            [_x, _y + 1]
        ];
        _neighbors = array_shuffle(_neighbors);

        for (var _i = 0; _i < 4; _i++) {
            var _nx = _neighbors[_i][0];
            var _ny = _neighbors[_i][1];

            if (_nx >= 0 && _nx < _w && _ny >= 0 && _ny < _h && _blob[# _nx, _ny] == 0) {
                ds_list_add(_open, [_nx, _ny]);
            }
        }
    }

    ds_list_destroy(_open);

    for (var _yy = 0; _yy < _h; _yy++) {
        for (var _xx = 0; _xx < _w; _xx++) {
            if (_blob[# _xx, _yy] == 1) {
                var _gx = bounds.left + _xx;
                var _gy = bounds.top + _yy;

                if (_gx >= 0 && _gx < grid_w && _gy >= 0 && _gy < grid_h) {
                    carve_tile(grid_, _gx, _gy);
                }
            }
        }
    }

    ds_grid_destroy(_blob);
}

function find_room_place(grid_, room_list, new_w, new_h, closeness, choas) {
    var grid_w = ds_grid_width(grid_);
    var grid_h = ds_grid_height(grid_);

    var half_nw = floor(new_w / 2);
    var half_nh = floor(new_h / 2);
	
    var n_rooms = ds_list_size(room_list);
    if (n_rooms <= 0) return undefined;
    for (var _i = 0; _i < n_rooms; _i++) {
        var _base = ds_list_find_value(room_list, _i);
		var bounds = _base.get_bounds()

        // Try 4 possible directions around this room with small random offset
        var _options = [
            [_base.x + irandom_range(-choas, choas), bounds.top - (half_nh + closeness)], // up
            [_base.x + irandom_range(-choas, choas), bounds.bottom + (half_nh + closeness)], // down
            [bounds.left - (half_nw + closeness), _base.y + irandom_range(-choas, choas)], // left
            [bounds.right + (half_nw + closeness), _base.y + irandom_range(-choas, choas)]  // right
        ];
        _options = array_shuffle(_options);

        for (var _j = 0; _j < 4; _j++) {
			var _cx = _options[_j][0];
            var _cy = _options[_j][1];
			var new_room = new struct_room(-1, _cx, _cy, new_w, new_h) 
			var new_bounds = new_room.get_bounds()
        
            if (new_bounds.left < 0 || new_bounds.right >= grid_w || 
			new_bounds.top < 0 || new_bounds.bottom >= grid_h) {
				new_room.clear()
				delete new_room
                continue;
            }

            var _valid = true;

            for (var _k = 0; _k < n_rooms; _k++) {
                var _check = ds_list_find_value(room_list, _k);
				
				var _o_bounds = _check.get_bounds()

                var _dx = 0;
                if (new_bounds.right < _o_bounds.left)      _dx = _o_bounds.left - new_bounds.right;
                else if (_o_bounds.right < new_bounds.left) _dx = new_bounds.left - _o_bounds.right;

                var _dy = 0;
                if (new_bounds.bottom < _o_bounds.top)      _dy = _o_bounds.top - new_bounds.bottom;
                else if (_o_bounds.bottom < new_bounds.top) _dy = new_bounds.top - _o_bounds.bottom;

                var _gap = sqrt(_dx * _dx + _dy * _dy);

                if (_gap < closeness) {
                    _valid = false;
                    break;
                }
            }
	
            if (_valid) {
                return new_room;
            } else {
				new_room.clear()
				delete new_room
			}
        }
    }

    return undefined;
}

function place_doors(grid_, room_) {
    var grid_w = ds_grid_width(grid_);
    var grid_h = ds_grid_height(grid_);

	var bounds = room_.get_bounds()

    // Horizontal edges
    for (var _x = bounds.left; _x <= bounds.right; _x++) {
        // Top edge
        if (grid_[# _x, bounds.top] == global.TILE_ROOM) {
            grid_[# _x, bounds.top] = global.TILE_DOOR;
        }
        // Bottom edge
        if (grid_[# _x, bounds.bottom] == global.TILE_ROOM) {
            grid_[# _x, bounds.bottom] = global.TILE_DOOR;
        }
    }

    // Vertical edges
    for (var _y = bounds.top; _y <= bounds.bottom; _y++) {
        // Left edge
        if (grid_[# bounds.left, _y] == global.TILE_ROOM) {
            grid_[# bounds.left, _y] = global.TILE_DOOR;
        }
        // Right edge
        if (grid_[# bounds.right, _y] == global.TILE_ROOM) {
            grid_[# bounds.right, _y] = global.TILE_DOOR;
        }
    }
}

function is_perimeter(grid_, _room_map, _x, _y){
	var bounds = _room_map.get_bounds()
	for (var yy = 0; yy <  _room_map.height; yy++) {
	        for (var xx = 0; xx < _room_map.width; xx++) {
	            var cx = bounds.left + xx;
	            var cy = bounds.top + yy;
	            if (cx >= 0 && cx < grid_size && cy >= 0 && cy < grid_size) {
	                if (xx == 0 || xx == _room_map.width-1 || yy == 0 || yy ==  _room_map.height-1) {
	                    if (cx == _x and cy == _y) {
							//show_debug_message("is p is ture");
							return true
	                    }
	                }
	            }
	        }
	    }
		return false
	}






