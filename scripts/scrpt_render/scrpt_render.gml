function draw_dungeon() {
    var grid_w = grid_size
    var grid_h = grid_size

    var px = floor(player_real_x + global.MAP_OFFSET_X);
    var py = floor(player_real_y + global.MAP_OFFSET_Y);

	var rpx = player_real_x + global.MAP_OFFSET_X;
    var rpy = player_real_y + global.MAP_OFFSET_Y;
    var bpx = rpx + lengthdir_x(1, player_angle + 180);
    var bpy = rpy + lengthdir_y(1, player_angle + 180);

    var pa = -player_angle;
    var cone_half_angle = 60;
    var cone_half_rad   = degtorad(cone_half_angle);

    matrix_set(matrix_world, matrix_build_identity());

    for (var i = 0; i < array_length(draw_pattern); i++) {
        var off = draw_pattern[i];
        var dx  = off[0];
        var dy  = off[1];

        var gx = px + dx;
        var gy = py + dy;
        if (gx < 0 || gx >= grid_w || gy < 0 || gy >= grid_h) continue;

        var wx = (player_real_x + global.MAP_OFFSET_X) + dx;
        var wy = (player_real_y + global.MAP_OFFSET_Y) + dy;

        var dist = point_distance(rpx, rpy, gx, gy);

        // Cone check
        var vec_x = wx - bpx;
        var vec_y = wy - bpy;
        var ang_to_cell = point_direction(0, 0, vec_x, -vec_y);
        var rel_angle = angle_difference(pa, ang_to_cell);
        if (abs(rel_angle) > cone_half_angle) continue;
		
        draw_cell(gx, gy, offset_x, offset_y, tile_width, tile_tall, dist);
    }

    matrix_set(matrix_world, matrix_build_identity());
}

function draw_cell(_gx, _gy, _offset_x, _offset_y, _tile_w, _tile_t, dist) {
	var tile_key = global.main_grid[# _gx, _gy];
    var tile_info = ds_map_find_value(global.tile_definitions, tile_key);
	if (tile_info = undefined) { return }
	if tile_info.is_transparent {
		gpu_set_zwriteenable(false);
	} else {
		gpu_set_zwriteenable(true);
	}
	var tint_color = get_tint_from_distance(dist);
	var _px = (_gx + _offset_x) * _tile_w
	var _py = (_gy + _offset_y) * _tile_w
	switch (tile_key) {
	    case global.TILE_WALL:
	        draw_wall(_px, _py, tile_info.sprite, tint_color);
	        break;
		
		case global.TILE_ROOM:
			draw_floor(_px, _py, 0, tile_info.sprite1, tint_color);
			draw_floor(_px, _py, tile_tall, tile_info.sprite, tint_color);
			break;
		case global.TILE_DOOR:
			var tiles_door = adjacent_tiles(_gx, _gy)
			
			draw_floor(_px, _py, 0, tile_info.sprite1, tint_color);
			draw_floor(_px, _py, tile_tall, tile_info.sprite2, tint_color);

		    if (tiles_door.left == global.TILE_WALL && tiles_door.right == global.TILE_WALL) {
		        draw_pane(_px, _py, 0, tile_info.sprite, tint_color);
		    }
		    else if (tiles_door.top == global.TILE_WALL && tiles_door.bottom == global.TILE_WALL) {
		        draw_pane(_px, _py, 90, tile_info.sprite, tint_color);
		    } else {
				// Handle: No proper connection
			}
			break
		case global.TILE_GLASS:
			var tiles = adjacent_tiles(_gx, _gy)
			var _top_info = ds_map_find_value(global.tile_definitions, tiles.top);
			var _bottom_info = ds_map_find_value(global.tile_definitions, tiles.bottom);
			var _left_info = ds_map_find_value(global.tile_definitions, tiles.left);
			var _right_info = ds_map_find_value(global.tile_definitions, tiles.right);
			
			draw_floor(_px, _py, 0, tile_info.sprite1, tint_color);
			draw_floor(_px, _py, tile_tall, tile_info.sprite2, tint_color);

		    if (_left_info.is_wall && _right_info.is_wall) {
		        draw_pane(_px, _py, 0, tile_info.sprite, tint_color);
		    }
		    else if (_top_info.is_wall && _bottom_info.is_wall) {
		        draw_pane(_px, _py, 90, tile_info.sprite, tint_color);
		    } else {
				// Handle: No proper connection possible
			}
	    default:
	        break;
	}
}

function get_tint_from_distance(dist) {
    var t = clamp(dist / (max_depth-2.75), 0, 1);
    var brightness = 1.0 - t;
    var cval = floor(brightness * 255);
    return make_color_rgb(cval, cval, cval);
}


function draw_topdown_dungeon_debug(__x, __y) {
    var tile_size = 2;
    var offset_x  = __x;
    var offset_y  = __y;

    var grid_w = ds_grid_width(global.main_grid);
    var grid_h = ds_grid_height(global.main_grid);

    for (var gy = 0; gy < grid_h; gy++) {
        for (var gx = 0; gx < grid_w; gx++) {
            var cell_type = global.main_grid[# gx, gy];
            if (cell_type == "void") {
                continue; // skip void cells
            }

            var x1 = offset_x + gx * tile_size;
            var y1 = offset_y + gy * tile_size;
            switch (cell_type) {
                case "wall":  draw_set_color(c_blue);   break;
                default:       draw_set_color(c_white); break;
            }
			draw_point(x1+1, y1+1);
        }
    }

    var player_gx = player_x + global.MAP_OFFSET_X;
    var player_gy = player_y + global.MAP_OFFSET_Y;

    var px = offset_x + player_gx * tile_size + tile_size * 0.5;
    var py = offset_y + player_gy * tile_size + tile_size * 0.5;

    draw_set_color(c_white);
    var line_len = tile_size * 2;
	var snapped = (round(angle_wrap(player_angle) / 90) mod 4);
    switch (snapped) {
        case 0: draw_line(px, py, px + line_len, py); break;
		case 1: draw_line(px, py, px, py - line_len); break;
        case 2: draw_line(px, py, px - line_len, py); break;
        case 3: draw_line(px, py, px, py + line_len); break;
    }

    draw_set_color(c_red);
    draw_point(px, py);

    draw_set_color(c_white);
}

function draw_topdown_dungeon_radar(__x, __y, _width) {
    var tile_size = 2;
    var _offset_x  = __x;
    var _offset_y  = __y;

    var grid_w = grid_size
    var grid_h = grid_size

    var player_gx = player_x + global.MAP_OFFSET_X;
    var player_gy = player_y + global.MAP_OFFSET_Y;

    // Center of the radar
    var center_x = _offset_x;
    var center_y = _offset_y;

    for (var gy = 0; gy < grid_h; gy++) {
        for (var gx = 0; gx < grid_w; gx++) {
            var dx = gx - player_gx;
            var dy = gy - player_gy;
            var dist = sqrt(dx * dx + dy * dy);
            if (dist > _width) continue;

            var cell_type = global.main_grid[# gx, gy];
            if (cell_type == "void") or (cell_type == "wall") {
                continue; // skip void cells
            }
			draw_set_color(c_white)

            var x1 = center_x + dx * tile_size;
            var y1 = center_y + dy * tile_size;
			
            // Set alpha falloff
            var alpha = 1.0 - (dist / _width);
            //draw_set_alpha(alpha);
			draw_set_alpha(1);
            draw_point(x1 + 1, y1 + 1);
        }
    }

    draw_set_alpha(1);

    
    // Draw player center point
    draw_set_color(c_red);
	center_x++;
	center_y++;

    // Draw facing direction
    draw_set_color(c_white);
    var line_len = tile_size * 2;
	var snapped = (round(angle_wrap(player_angle) / 90) mod 4);
    switch (snapped) {
        case 0: draw_line(center_x, center_y, center_x + line_len, center_y); break;
		case 1: draw_line(center_x, center_y, center_x, center_y - line_len); break;
        case 2: draw_line(center_x, center_y, center_x - line_len, center_y); break;
        case 3: draw_line(center_x, center_y, center_x, center_y + line_len); break;
    }

    draw_set_color(c_red);
    draw_point(center_x, center_y);

    draw_set_color(c_white);
}

function draw_room_debug_view(room_list, offset_x, offset_y, scale) {
	draw_set_font(fnt_debug)
    var room_count = ds_list_size(room_list);

    for (var i = 0; i < room_count; i++) {
        var _room = ds_list_find_value(room_list, i);
        var bounds = _room.get_bounds();

        var left   = offset_x + bounds.left   * scale;
        var right  = offset_x + bounds.right * scale+scale;
        var top    = offset_y + bounds.top   * scale;
        var bottom = offset_y + bounds.bottom * scale+scale;

        // Draw room rectangle
        draw_set_color(c_red);
        draw_rectangle(left, top, right, bottom, true);

        // Draw center point
        var cx = offset_x + _room.x * scale + scale * 0.5;
        var cy = offset_y + _room.y * scale + scale * 0.5;

        draw_set_color(c_red);
        draw_circle(cx, cy, 2, true);
    }

    // Draw connections
    for (var i = 0; i < room_count; i++) {
        var _room = ds_list_find_value(room_list, i);
        var cx1 = offset_x + _room.x * scale + scale * 0.5;
        var cy1 = offset_y + _room.y * scale + scale * 0.5;

        var conn_count = ds_list_size(_room.connected_rooms);
        for (var j = 0; j < conn_count; j++) {
            var conn_id = ds_list_find_value(_room.connected_rooms, j);
            var other_room = undefined;

            // Find the other room by ID
            for (var k = 0; k < room_count; k++) {
                var test_room = ds_list_find_value(room_list, k);
                if (test_room.id == conn_id) {
                    other_room = test_room;
                    break;
                }
            }

            if (other_room != undefined) {
                var cx2 = offset_x + other_room.x * scale + scale * 0.5;
                var cy2 = offset_y + other_room.y * scale + scale * 0.5;

                draw_set_color(c_red);
                draw_line(cx1, cy1, cx2, cy2);
            }
        }
    }

    draw_set_color(c_white); // reset
}



