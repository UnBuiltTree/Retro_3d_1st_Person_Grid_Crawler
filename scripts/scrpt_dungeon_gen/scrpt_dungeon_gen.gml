function create_connection(grid_, _x1, _y1, _x2, _y2) {
    var grid_w = ds_grid_width(grid_);
    var grid_h = ds_grid_height(grid_);

    // L-shaped: go horizontal first, then vertical
    var corner_x = _x2;
    var corner_y = _y1;

    var start_x = min(_x1, corner_x);
    var end_x = max(_x1, corner_x);
    for (var _x = start_x; _x <= end_x; _x++) {
        carve_tile(grid_, _x, _y1);
    }

    var start_y = min(_y1, _y2);
    var end_y = max(_y1, _y2);
    for (var _y = start_y; _y <= end_y; _y++) {
        carve_tile(grid_, _x2, _y);
    }
}

function carve_tile(grid_, _x, _y) {
    var grid_w = ds_grid_width(grid_);
    var grid_h = ds_grid_height(grid_);

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
    var _x2 = ds_map_find_value(room2, "_x");
    var _y2 = ds_map_find_value(room2, "_y");

    create_connection(grid_, _x1, _y1, _x2, _y2);
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

    var grid_w = ds_grid_width(grid_);
    var grid_h = ds_grid_height(grid_);

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

function find_room_place(grid_, room_list, new_w, new_h, closeness) {
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
            [_base_x + irandom_range(-1, 1), _base_y - (_base_hh + half_nh + closeness)], // up
            [_base_x + irandom_range(-1, 1), _base_y + (_base_hh + half_nh + closeness)], // down
            [_base_x - (_base_hw + half_nw + closeness), _base_y + irandom_range(-1, 1)], // left
            [_base_x + (_base_hw + half_nw + closeness), _base_y + irandom_range(-1, 1)]  // right
        ];
        array_shuffle(_options);

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




