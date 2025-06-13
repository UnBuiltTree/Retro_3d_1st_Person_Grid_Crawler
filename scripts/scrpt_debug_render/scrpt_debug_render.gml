function draw_topdown_dungeon_debug(__x, __y, scale = 1) {
    var tile_size = scale;
    var grid_w = ds_grid_width(global.main_grid);
    var grid_h = ds_grid_height(global.main_grid);

    var offset_x = __x - (grid_w * tile_size) / 2;
    var offset_y = __y - (grid_h * tile_size) / 2;

    for (var gy = 0; gy < grid_h; gy++) {
        for (var gx = 0; gx < grid_w; gx++) {
            var cell_type = global.main_grid[# gx, gy];
            if (cell_type == "void") continue;

            var x1 = offset_x + gx * tile_size;
            var y1 = offset_y + gy * tile_size;

            switch (cell_type) {
                case "wall": draw_set_color(c_blue); break;
                case "door": draw_set_color(c_fuchsia); break;
                default: draw_set_color(c_white); break;
            }

            draw_point(x1, y1);
        }
    }

    var player_gx = global.player_x + global.MAP_OFFSET_X;
    var player_gy = global.player_y + global.MAP_OFFSET_Y;

    var px = offset_x + player_gx * tile_size + tile_size * 0.5;
    var py = offset_y + player_gy * tile_size + tile_size * 0.5;

    draw_set_color(c_gray);
    var line_len = tile_size * 2;
    var snapped = (round(angle_wrap(global.player_angle) / 90) mod 4);
    switch (snapped) {
        case 0: draw_line(px, py, px + line_len, py); break;
        case 1: draw_line(px, py, px, py - line_len); break;
        case 2: draw_line(px, py, px - line_len, py); break;
        case 3: draw_line(px, py, px, py + line_len); break;
    }

    draw_set_color(c_red);
    draw_circle(px, py, tile_size * 0.3, false);
    draw_set_color(c_white);
}

function draw_room_debug_view(room_list, center_x, center_y, scale = 1) {
    draw_set_font(fnt_debug);
    var tile_size = scale;

    var grid_w = ds_grid_width(global.main_grid);
    var grid_h = ds_grid_height(global.main_grid);

    var offset_x = center_x - (grid_w * tile_size) / 2;
    var offset_y = center_y - (grid_h * tile_size) / 2;

    var room_count = ds_list_size(room_list);

    for (var i = 0; i < room_count; i++) {
        var _room = ds_list_find_value(room_list, i);
        var bounds = _room.get_bounds();

        var left   = offset_x + bounds.left   * tile_size;
        var right  = offset_x + (bounds.right) * tile_size;
        var top    = offset_y + bounds.top    * tile_size;
        var bottom = offset_y + (bounds.bottom) * tile_size;

        var conn_count = ds_list_size(_room.connected_rooms);
        switch (conn_count) {
            case 1: draw_set_color(c_fuchsia); break;
            case 2: draw_set_color(c_red); break;
            case 3: draw_set_color(c_orange); break;
            case 4: draw_set_color(c_yellow); break;
            case 5: draw_set_color(c_green); break;
            default: draw_set_color(c_white); break;
        }

        draw_rectangle(left, top, right, bottom, true);

        var cx = offset_x + _room.x * tile_size -tile_size/2;
        var cy = offset_y + _room.y * tile_size -tile_size/2;
        var cs = ((_room.width + _room.height) / 2) * tile_size;
        draw_circle(cx, cy, cs / 4, true);
    }

    for (var i = 0; i < room_count; i++) {
        var _room = ds_list_find_value(room_list, i);
        var cx1 = offset_x + _room.x * tile_size-tile_size/2;
        var cy1 = offset_y + _room.y * tile_size-tile_size/2;

        var conn_count = ds_list_size(_room.connected_rooms);
        for (var j = 0; j < conn_count; j++) {
            var conn_id = ds_list_find_value(_room.connected_rooms, j);
            var other_room = undefined;

            for (var k = 0; k < room_count; k++) {
                var test_room = ds_list_find_value(room_list, k);
                if (test_room.id == conn_id) {
                    other_room = test_room;
                    break;
                }
            }

            if (other_room != undefined) {
                var cx2 = offset_x + other_room.x * tile_size-tile_size/2;
                var cy2 = offset_y + other_room.y * tile_size-tile_size/2;
                draw_set_color(c_red);
                draw_line(cx1, cy1, cx2, cy2);
            }
        }
    }

    // Draw Player
    var player_draw_x = offset_x + (global.player_x + global.MAP_OFFSET_X) * tile_size;
    var player_draw_y = offset_y + (global.player_y + global.MAP_OFFSET_Y) * tile_size;
    var dir_length = tile_size * 3;

    draw_set_color(c_lime);
    draw_circle(player_draw_x, player_draw_y, tile_size * 0.5, true);

    var dir_rad = angle_wrap(global.player_angle);
    var dx = lengthdir_x(dir_length, dir_rad);
    var dy = lengthdir_y(dir_length, dir_rad);
    draw_line(player_draw_x, player_draw_y, player_draw_x + dx, player_draw_y + dy);

    draw_set_color(c_white);
}

function debug_draw_pattern(center_x, center_y, draw_pattern, scale = 1) {
    var total = array_length(draw_pattern);

    for (var i = 0; i < total; i++) {
        var offset = draw_pattern[i];
        var dx = offset[0];
        var dy = offset[1];

        var _x = center_x + dx * scale;
        var _y = center_y + dy * scale;

        var brightness = 1 - (i / total);
        var col = make_color_rgb(brightness * 255, brightness * 255, brightness * 255);

        draw_set_color(col);
        draw_point(_x, _y)
    }

    draw_set_color(c_white);
}