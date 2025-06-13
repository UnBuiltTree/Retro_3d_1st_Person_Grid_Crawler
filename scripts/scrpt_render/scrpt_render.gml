function draw_dungeon() {
    var grid_w = grid_size
    var grid_h = grid_size

    var px = round(player_real_x + global.MAP_OFFSET_X);
    var py = round(player_real_y + global.MAP_OFFSET_Y);

	var rpx = player_real_x + global.MAP_OFFSET_X;
    var rpy = player_real_y + global.MAP_OFFSET_Y;
	
    var bpx = rpx + lengthdir_x(2, player_angle + 180);
    var bpy = rpy + lengthdir_y(2, player_angle + 180);

    var pa = -player_angle;
    var cone_half_angle = 45;
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

function draw_topdown_dungeon_radar(__x, __y, _width) {
    var grid = global.main_grid;
    var half_size = _width div 2;
    var center_x = __x;
    var center_y = __y;
    var player_gx = global.player_x + global.MAP_OFFSET_X;
    var player_gy = global.player_y + global.MAP_OFFSET_Y;
    var tile_size = 2;

    for (var gy = max(0, player_gy - half_size); gy < min(grid_size, player_gy + half_size); gy++) {
        for (var gx = max(0, player_gx - half_size); gx < min(grid_size, player_gx + half_size); gx++) {
            
            var cell_type = grid[# gx, gy];
            if (cell_type == "void" || cell_type == "wall") continue;

            var dx = gx - player_gx;
            var dy = gy - player_gy;
            var x1 = center_x + dx * tile_size;
            var y1 = center_y + dy * tile_size;

            draw_set_color(c_white);
            draw_point(x1 + 1, y1 + 1);
        }
    }

    draw_set_alpha(1);

    center_x++;
    center_y++;
    draw_set_color(c_red);
    draw_point(center_x, center_y);

    draw_set_color(c_gray);
    var line_len = 2;
    var dir = (round(angle_wrap(global.player_angle) / 90) mod 4);
    switch (dir) {
        case 0: draw_line(center_x, center_y, center_x + line_len, center_y); break;
        case 1: draw_line(center_x, center_y, center_x, center_y - line_len); break;
        case 2: draw_line(center_x, center_y, center_x - line_len, center_y); break;
        case 3: draw_line(center_x, center_y, center_x, center_y + line_len); break;
    }

    draw_set_color(c_white);
}
