function create_connection(grid_, _x1, _y1, _x2, _y2, _w1 = 1, _h1 = 1, _w2 = 1, _h2 = 1) {
    var grid_w = ds_grid_width(grid_)
    var grid_h = ds_grid_height(grid_)

    // Room 1 bounds
    var _left1   = _x1 - floor(_w1 / 2);
    var _right1  = _x1 + floor((_w1 - 1) / 2);
    var _top1    = _y1 - floor(_h1 / 2);
    var _bottom1 = _y1 + floor((_h1 - 1) / 2);

    // Room 2 bounds
    var _left2   = _x2 - floor(_w2 / 2);
    var _right2  = _x2 + floor((_w2 - 1) / 2);
    var _top2    = _y2 - floor(_h2 / 2);
    var _bottom2 = _y2 + floor((_h2 - 1) / 2);

    // Check for vertical straight connections (shared X, exclude edges)
    var _min_shared_x = max(_left1, _left2);
    var _max_shared_x = min(_right1, _right2);
    if (_min_shared_x <= _max_shared_x) {
        var _valid_x_list = [];
        for (var _x = _min_shared_x; _x <= _max_shared_x; _x++) {
            if (
                _x != _left1 && _x != _right1 &&
                _x != _left2 && _x != _right2
            ) {
                array_push(_valid_x_list, _x);
            }
        }

        if (array_length(_valid_x_list) > 0) {
            var _shared_x = _valid_x_list[irandom(array_length(_valid_x_list) - 1)];
            for (var _y = min(_y1, _y2); _y <= max(_y1, _y2); _y++) {
                carve_tile(grid_, _shared_x, _y);
            }
            return;
        }
    }

    // Check for horizontal straight connections (shared Y, exclude edges)
    var _min_shared_y = max(_top1, _top2);
    var _max_shared_y = min(_bottom1, _bottom2);
    if (_min_shared_y <= _max_shared_y) {
        var _valid_y_list = [];
        for (var _y = _min_shared_y; _y <= _max_shared_y; _y++) {
            if (
                _y != _top1 && _y != _bottom1 &&
                _y != _top2 && _y != _bottom2
            ) {
                array_push(_valid_y_list, _y);
            }
        }

        if (array_length(_valid_y_list) > 0) {
            var _shared_y = _valid_y_list[irandom(array_length(_valid_y_list) - 1)];
            for (var _x = min(_x1, _x2); _x <= max(_x1, _x2); _x++) {
                carve_tile(grid_, _x, _shared_y);
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
    var grid_w = ds_grid_width(grid_)
    var grid_h = ds_grid_height(grid_)

    if (_x >= 0 && _x < grid_w && _y >= 0 && _y < grid_h) {
        grid_[# _x, _y] = global.TILE_ROOM;

        for (var dx = -1; dx <= 1; dx++) {
            for (var dy = -1; dy <= 1; dy++) {
                var _nx = _x + dx;
                var _ny = _y + dy;

                if ((dx != 0 || dy != 0) && _nx >= 0 && _nx < grid_w && _ny >= 0 && _ny < grid_h) {
                    if (grid_[# _nx, _ny] != global.TILE_ROOM) {
                        grid_[# _nx, _ny] = global.TILE_WALL;
                    }
                }
            }
        }
    }
}

function connect_rooms(grid_, room_list, room_id1, room_id2) {
    var room1 = ds_list_find_value(room_list, room_id1);
    var room2 = ds_list_find_value(room_list, room_id2);

    if (room1 == undefined || room2 == undefined) {
        show_debug_message("Error: connect_rooms - invalid room IDs");
        return;
    }

    var _x1 = ds_map_find_value(room1, "_x");
    var _y1 = ds_map_find_value(room1, "_y");
    var _w1 = ds_map_find_value(room1, "width");
    var _h1 = ds_map_find_value(room1, "height");

    var _x2 = ds_map_find_value(room2, "_x");
    var _y2 = ds_map_find_value(room2, "_y");
    var _w2 = ds_map_find_value(room2, "width");
    var _h2 = ds_map_find_value(room2, "height");

    create_connection(grid_, _x1, _y1, _x2, _y2, _w1, _h1, _w2, _h2);
}


function get_room_center(room_list, room_id) {
    var _room = ds_list_find_value(room_list, room_id);
    if (_room == undefined) {
        show_debug_message("Error: get_room_center - invalid room ID: " + string(room_id));
        return undefined;
    }

    var _x = ds_map_find_value(_room, "_x");
    var _y = ds_map_find_value(_room, "_y");
    return [_x, _y];
}

function create_room(grid_, room_list, room_id, x_center, y_center, room_w, room_h) {
    var room_ = ds_map_create();
    ds_map_add(room_, "id", room_id);
    ds_map_add(room_, "_x", x_center);
    ds_map_add(room_, "_y", y_center);
    ds_map_add(room_, "width", room_w);
    ds_map_add(room_, "height", room_h);
    ds_map_add(room_, "connected_rooms", ds_list_create());
    ds_list_add(room_list, room_);
}

function render_room(grid_, _room_map) {
    var _x_center = ds_map_find_value(_room_map, "_x");
    var _y_center = ds_map_find_value(_room_map, "_y");
    var width     = ds_map_find_value(_room_map, "width");
    var height    = ds_map_find_value(_room_map, "height");

    var _x_start = _x_center - floor(width/2);
    var _y_start = _y_center - floor(height/2);

    var grid_w = ds_grid_width(grid_)
    var grid_h = ds_grid_height(grid_)

    for (var yy = 0; yy < height; yy++) {
        for (var xx = 0; xx < width; xx++) {
            var cx = _x_start + xx;
            var cy = _y_start + yy;
            if (cx >= 0 && cx < grid_w && cy >= 0 && cy < grid_h) {
                // Perimeter → WALL unless it's already a DOOR
                if (xx == 0 || xx == width-1 || yy == 0 || yy == height-1) {
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
    var _x_center = ds_map_find_value(_room_map, "_x");
    var _y_center = ds_map_find_value(_room_map, "_y");
    var _w        = ds_map_find_value(_room_map, "width")+1;
    var _h        = ds_map_find_value(_room_map, "height")+1;

    var grid_w = ds_grid_width(grid_)
    var grid_h = ds_grid_height(grid_)

    var _x0 = _x_center - floor(_w / 2);
    var _y0 = _y_center - floor(_h / 2);

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
                var _gx = _x0 + _xx;
                var _gy = _y0 + _yy;

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

        var _base_x = ds_map_find_value(_base, "_x");
        var _base_y = ds_map_find_value(_base, "_y");
        var _base_w = ds_map_find_value(_base, "width");
        var _base_h = ds_map_find_value(_base, "height");
        var _base_hw = floor(_base_w / 2);
        var _base_hh = floor(_base_h / 2);

        // Try 4 possible directions around this room with small random offset
        var _options = [
            [_base_x + irandom_range(-choas, choas), _base_y - (_base_hh + half_nh + closeness)], // up
            [_base_x + irandom_range(-choas, choas), _base_y + (_base_hh + half_nh + closeness)], // down
            [_base_x - (_base_hw + half_nw + closeness), _base_y + irandom_range(-choas, choas)], // left
            [_base_x + (_base_hw + half_nw + closeness), _base_y + irandom_range(-choas, choas)]  // right
        ];
        _options = array_shuffle(_options);

        for (var _j = 0; _j < 4; _j++) {
            var _cx = _options[_j][0];
            var _cy = _options[_j][1];

            if (_cx - half_nw < 0 || _cx + half_nw >= grid_w ||
                _cy - half_nh < 0 || _cy + half_nh >= grid_h) {
                continue;
            }

            var _new_left   = _cx - half_nw;
            var _new_top    = _cy - half_nh;
            var _new_right  = _new_left + new_w - 1;
            var _new_bottom = _new_top  + new_h - 1;

            var _valid = true;

            for (var _k = 0; _k < n_rooms; _k++) {
                var _check = ds_list_find_value(room_list, _k);

                var _ox = ds_map_find_value(_check, "_x");
                var _oy = ds_map_find_value(_check, "_y");
                var _ow = ds_map_find_value(_check, "width");
                var _oh = ds_map_find_value(_check, "height");
                var _ohw = floor(_ow / 2);
                var _ohh = floor(_oh / 2);

                var _o_left   = _ox - _ohw;
                var _o_top    = _oy - _ohh;
                var _o_right  = _o_left + _ow - 1;
                var _o_bottom = _o_top  + _oh - 1;

                var _dx = 0;
                if (_new_right < _o_left)      _dx = _o_left - _new_right;
                else if (_o_right < _new_left) _dx = _new_left - _o_right;

                var _dy = 0;
                if (_new_bottom < _o_top)      _dy = _o_top - _new_bottom;
                else if (_o_bottom < _new_top) _dy = _new_top - _o_bottom;

                var _gap = sqrt(_dx * _dx + _dy * _dy);

                if (_gap < closeness) {
                    _valid = false;
                    break;
                }
            }

            if (_valid) {
                return [_cx, _cy];
            }
        }
    }

    return undefined;
}



function closest_room(room_list, room_id) {
    var nRooms = ds_list_size(room_list);
    if (nRooms < 2) return undefined; // No other room to compare

    var base_xy = get_room_center(room_list, room_id);
    if (base_xy == undefined) return undefined;

    var base_x = base_xy[0];
    var base_y = base_xy[1];

    var closest_id = undefined;
    var best_dist = infinity;

    for (var i = 0; i < nRooms; i++) {
        if (i == room_id) continue;

        var other_xy = get_room_center(room_list, i);
        if (other_xy == undefined) continue;

        var dx = other_xy[0] - base_x;
        var dy = other_xy[1] - base_y;
        var dist = sqrt(dx * dx + dy * dy);

        if (dist < best_dist) {
            best_dist = dist;
            closest_id = i;
        }
    }

    return closest_id;
}


function place_doors(grid_, room_) {
    var grid_w = ds_grid_width(grid_);
    var grid_h = ds_grid_height(grid_);

    var _cx = ds_map_find_value(room_, "_x");
    var _cy = ds_map_find_value(room_, "_y");
    var _w  = ds_map_find_value(room_, "width");
    var _h  = ds_map_find_value(room_, "height");

    var _x0 = _cx - floor(_w / 2);
    var _y0 = _cy - floor(_h / 2);
    var _x1 = _x0 + _w - 1;
    var _y1 = _y0 + _h - 1;

    // Horizontal edges
    for (var _x = _x0; _x <= _x1; _x++) {
        // Top edge
        if (grid_[# _x, _y0] == global.TILE_ROOM) {
            grid_[# _x, _y0] = global.TILE_DOOR;
        }
        // Bottom edge
        if (grid_[# _x, _y1] == global.TILE_ROOM) {
            grid_[# _x, _y1] = global.TILE_DOOR;
        }
    }

    // Vertical edges
    for (var _y = _y0; _y <= _y1; _y++) {
        // Left edge
        if (grid_[# _x0, _y] == global.TILE_ROOM) {
            grid_[# _x0, _y] = global.TILE_DOOR;
        }
        // Right edge
        if (grid_[# _x1, _y] == global.TILE_ROOM) {
            grid_[# _x1, _y] = global.TILE_DOOR;
        }
    }
}







