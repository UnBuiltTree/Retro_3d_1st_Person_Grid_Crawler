function draw_textured_dungeon() {
    var view_w       = 360;
    var view_h       = 240;
    var center_x     = view_w / 2;
    var center_y     = view_h / 2;
    var fov_angle    = 45;                        // field of view in degrees
    var half_fov_rad = (fov_angle / 2) * (pi / 180);


    var frac_forward;
    if (player_facing == 0) {
        // Facing North: dy = -1
        var fy = player_real_y - floor(player_real_y);
        frac_forward = 1 - fy;
    }
    else if (player_facing == 2) {
        // Facing South: dy = +1
        frac_forward = player_real_y - floor(player_real_y);
    }
    else if (player_facing == 1) {
        // Facing East: dx = +1
        frac_forward = player_real_x - floor(player_real_x);
    }
    else {
        // Facing West: dx = -1
        var fx = player_real_x - floor(player_real_x);
        frac_forward = 1 - fx;
    }

    // Precompute left/right directions, used for side-wall checks)
    var left_dir  = (player_facing + 3) mod 4;
    var right_dir = (player_facing + 1) mod 4;

    for (var i = max_depth; i >= 1; i--) {

        var d_front = i - frac_forward; 
        var d_back  = (i + 1) - frac_forward;

        var scale_front  = center_y / d_front;
        var scale_back   = center_y / d_back;
        var top_front    = center_y - scale_front;
        var bottom_front = center_y + scale_front;
        var top_back     = center_y - scale_back;
        var bottom_back  = center_y + scale_back;

        var _subdivisions = round( lerp(24, 4, (i - 1) / (max_depth - 1)) );

		// The half-width in map-space at distance i:
        var half_view_width = tan(half_fov_rad) * i;
        var max_offset      = ceil(half_view_width);

        for (var abs_offset = max_offset; abs_offset >= 0; abs_offset--) {
			var offset = 0;
            if (abs_offset > 0) {
                offset = -abs_offset;
                draw_cell(i, offset, frac_forward, center_x, center_y, scale_front, scale_back, top_front, bottom_front, top_back, bottom_back, _subdivisions, left_dir, right_dir);
            }
            {
                offset = abs_offset;
                draw_cell(i, offset, frac_forward, center_x, center_y, scale_front, scale_back, top_front, bottom_front, top_back, bottom_back, _subdivisions, left_dir, right_dir);
            }
        }
    }
}

function draw_cell(i, offset, frac_forward, center_x, center_y, scale_front, scale_back, top_front, bottom_front, top_back, bottom_back, _subdivisions, left_dir, right_dir) {
    var dist_along = i - frac_forward;

    var raw_x = player_real_x + dx[player_facing] * dist_along + dx[(player_facing + 1) mod 4] * offset;
    var raw_y = player_real_y + dy[player_facing] * dist_along + dy[(player_facing + 1) mod 4] * offset;

    var tile_x = floor(raw_x);
    var tile_y = floor(raw_y);

    // Convert “world” coords to main_grid indices
    var gx = tile_x + global.MAP_OFFSET_X;
    var gy = tile_y + global.MAP_OFFSET_Y;

    if (gy < 0 || gy >= ds_grid_height(global.main_grid)
     || gx < 0 || gx >= ds_grid_width(global.main_grid))
    {
        return;
    }

    // Fetch the cell from main_grid
    var cell_type = global.main_grid[# gx, gy];
    var cell_info = ds_map_find_value(global.tile_definitions, cell_type);
    if (cell_info == undefined) return;

    var is_wall = cell_info.is_wall;
    var sprite  = cell_info.sprite;
    if (sprite == -1) return;

    // Screen-space coordinates for this slice’s trapezoid
    var x_off_FL = (offset - 0.5) * scale_front * 3;
    var x_off_FR = (offset + 0.5) * scale_front * 3;
    var x_off_BL = (offset - 0.5) * scale_back * 3;
    var x_off_BR = (offset + 0.5) * scale_back * 3;

    var left_front  = center_x + x_off_FL;
    var right_front = center_x + x_off_FR;
    var left_back   = center_x + x_off_BL;
    var right_back  = center_x + x_off_BR;

    var tint_color = get_tint_from_distance(dist_along);

    if (is_wall) {
        // Draw the wall slice as a vertical quad
        draw_textured_quad(
            left_front,  top_front,
            right_front, top_front,
            right_front, bottom_front,
            left_front,  bottom_front,
            sprite, tint_color, 1
        );
    } else {
        // Draw the floor/ceiling slice
        draw_textured_quad(
            left_back,   bottom_back,
            right_back,  bottom_back,
            right_front, bottom_front,
            left_front,  bottom_front,
            sprite, tint_color, _subdivisions
        );

        // Check left-side wall (if offset < 1)
        if (offset < 1) {
            var lx = tile_x + dx[left_dir];
            var ly = tile_y + dy[left_dir];
            var gx2 = lx + global.MAP_OFFSET_X;
            var gy2 = ly + global.MAP_OFFSET_Y;
            if (gy2 >= 0 && gy2 < ds_grid_height(global.main_grid)
             && gx2 >= 0 && gx2 < ds_grid_width(global.main_grid))
            {
                var side_type = global.main_grid[# gx2, gy2];
                var side_info = ds_map_find_value(global.tile_definitions, side_type);
                if (side_info != undefined && side_info.is_wall) {
                    var side_sprite = side_info.sprite;
                    if (side_sprite != -1) {
                        draw_textured_quad(
                            left_back,   top_back,
                            left_front,  top_front,
                            left_front,  bottom_front,
                            left_back,   bottom_back,
                            side_sprite, tint_color, _subdivisions
                        );
                    }
                }
            }
        }

        // Check right-side wall (if offset > –1)
        if (offset > -1) {
            var rx = tile_x + dx[right_dir];
            var ry = tile_y + dy[right_dir];
            var gx3 = rx + global.MAP_OFFSET_X;
            var gy3 = ry + global.MAP_OFFSET_Y;
            if (gy3 >= 0 && gy3 < ds_grid_height(global.main_grid)
             && gx3 >= 0 && gx3 < ds_grid_width(global.main_grid))
            {
                var side_type = global.main_grid[# gx3, gy3];
                var side_info = ds_map_find_value(global.tile_definitions, side_type);
                if (side_info != undefined && side_info.is_wall) {
                    var side_sprite =side_info.sprite;
                    if (side_sprite != -1) {
                        draw_textured_quad(
                            right_front, top_front,
                            right_back,  top_back,
                            right_back,  bottom_back,
                            right_front, bottom_front,
                            side_sprite, tint_color, _subdivisions
                        );
                    }
                }
            }
        }
    }
}

function get_tint_from_distance(dist) {
    var t = clamp(dist / max_depth, 0, 1);
    var brightness = 1.0 - t;
    var cval = floor(brightness * 255);
    return make_color_rgb(cval, cval, cval);
}

function draw_textured_quad(x1, y1, x2, y2, x3, y3, x4, y4, sprite, color, subdivisions = 10) {
	
    var tex = sprite_get_texture(sprite, 0);
    draw_set_color(color);
	
	/*
	Ok this uses subdivisioning to minimise and issue with game maker being unable to draw
	stretched textures, like trapezoids. So i can minimize this issue by spreading the issue out over
	a bunch of subdivisions where it becomes far less noticeable.
		~Unbuilt
	*/
    
    for (var i = 0; i < subdivisions; i++) {
        var t0 = i / subdivisions;
        var t1 = (i + 1) / subdivisions;

        // Top edge interpolation:
        var xa_top = lerp(x1, x2, t0);
        var ya_top = lerp(y1, y2, t0);
        var xb_top = lerp(x1, x2, t1);
        var yb_top = lerp(y1, y2, t1);

        // Bottom edge interpolation:
        var xa_bot = lerp(x4, x3, t0);
        var ya_bot = lerp(y4, y3, t0);
        var xb_bot = lerp(x4, x3, t1);
        var yb_bot = lerp(y4, y3, t1);

        // Texture‐coordinate U’s span from 0 to 1 across the quad
        var u0 = t0;
        var u1 = t1;

        // Begin drawing a textured triangle list
        draw_primitive_begin_texture(pr_trianglelist, tex);

        // Upper‐left, Upper‐right, Lower‐right
        draw_vertex_texture(xa_top, ya_top, u0, 0);
        draw_vertex_texture(xb_top, yb_top, u1, 0);
        draw_vertex_texture(xb_bot, yb_bot, u1, 1);

        // Upper‐left, Lower‐right, Lower‐left
        draw_vertex_texture(xa_top, ya_top, u0, 0);
        draw_vertex_texture(xb_bot, yb_bot, u1, 1);
        draw_vertex_texture(xa_bot, ya_bot, u0, 1);

        draw_primitive_end();
    }
}

// ============================================================================
// draw_topdown_dungeon(__x, __y)
// ----------------------------------------------------------------------------
// Now iterates over global.main_grid rather than global.map_grid.
// ============================================================================
function draw_topdown_dungeon(__x, __y) {
    var tile_size = 12;
    var offset_x  = __x;
    var offset_y  = __y;

    var grid_w = ds_grid_width(global.main_grid);
    var grid_h = ds_grid_height(global.main_grid);

    // Loop through the 256×256 grid
    for (var _y = 0; _y < grid_h; _y++) {
        for (var _x = 0; _x < grid_w; _x++) {
            var cell_type = global.main_grid[# _x, _y];
            var x1 = offset_x + _x * tile_size;
            var y1 = offset_y + _y * tile_size;

            if (cell_type == "floor1") {
                draw_sprite(spr_radar_tile, 0, x1, y1);
            }
        }
    }

    // Draw player position and facing arrow
    var px = offset_x + player_x * tile_size + tile_size / 2;
    var py = offset_y + player_y * tile_size + tile_size / 2;
    draw_sprite_ext(
        spr_radar_player, 0,
        px, py,
        1, 1,
        player_facing * -90,
        c_red, 1
    );
}

// function to get cell distance from the player
function cell_distance(cx, cy) {
    return point_distance(cx, cy, player_x, player_y);
}

function cell_tint(cx, cy, max_dist = 7) {
    var dist = point_distance(cx, cy, player_x, player_y);
    

    var norm = clamp(dist / max_dist, 0, 1);
    var brightness = 1 - norm;
    
    // Convert to 256 grayscale
    var gray_value = floor(brightness * 255);
    return make_color_rgb(gray_value, gray_value, gray_value);
}

/*
function draw_topdown_dungeon(__x, __y) {
    var tile_size = 12;
    var offset_x  = __x;
    var offset_y  = __y;

    var grid_w = ds_grid_width(global.map_grid);
    var grid_h = ds_grid_height(global.map_grid);

    // Loop through the DS grid
    for (var _y = 0; _y < grid_h; _y++) {
        for (var _x = 0; _x < grid_w; _x++) {
            var cell_type = ds_grid_get(global.map_grid, _x, _y);
            var x1 = offset_x + _x * tile_size;
            var y1 = offset_y + _y * tile_size;

            if (cell_type == "floor1") {
                draw_sprite(spr_radar_tile, 0, x1, y1);
            }
        }
    }

    // Draw player position and facing arrow
    var px = offset_x + player_x * tile_size + tile_size / 2;
    var py = offset_y + player_y * tile_size + tile_size / 2;
    draw_sprite_ext(spr_radar_player, 0, px, py, 1, 1, player_facing * -90, c_red, 1);
}
*/

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
                case "floor1":
                    draw_set_color(c_dkgray);
                    break;
                case "wall1":
                    draw_set_color(c_ltgray);
                    break;
                case "door1":
                    draw_set_color(c_blue);
                    break;
                default:
                    draw_set_color(c_yellow);
                    break;
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
    switch (player_facing) {
        case 0: draw_line(px, py, px, py - line_len); break;
        case 1: draw_line(px, py, px + line_len, py); break;
        case 2: draw_line(px, py, px, py + line_len); break;
        case 3: draw_line(px, py, px - line_len, py); break;
    }

    draw_set_color(c_red);
    draw_point(px, py);

    draw_set_color(c_white);
}

function draw_topdown_dungeon_radar(__x, __y, _width) {
    var tile_size = 2;
    var offset_x  = __x;
    var offset_y  = __y;

    var grid_w = ds_grid_width(global.main_grid);
    var grid_h = ds_grid_height(global.main_grid);

    var player_gx = player_x + global.MAP_OFFSET_X;
    var player_gy = player_y + global.MAP_OFFSET_Y;

    // Center of the radar
    var center_x = offset_x;
    var center_y = offset_y;

    for (var gy = 0; gy < grid_h; gy++) {
        for (var gx = 0; gx < grid_w; gx++) {
            var dx = gx - player_gx;
            var dy = gy - player_gy;
            var dist = sqrt(dx * dx + dy * dy);
            if (dist > _width) continue;

            var cell_type = global.main_grid[# gx, gy];
            if (cell_type == "void") continue;

            var x1 = center_x + dx * tile_size;
            var y1 = center_y + dy * tile_size;

            // Set color based on cell type
            switch (cell_type) {
                case "floor1": draw_set_color(c_dkgray); break;
                case "wall1":  draw_set_color(c_ltgray); break;
                case "door1":  draw_set_color(c_blue);   break;
                default:       draw_set_color(c_yellow); break;
            }

            // Set alpha falloff
            var alpha = 1.0 - (dist / _width);
            draw_set_alpha(alpha);
            draw_point(x1 + 1, y1 + 1);
        }
    }

    draw_set_alpha(1);
    
    // Draw player center point
    draw_set_color(c_red);
    draw_point(center_x + 1, center_y + 1);

    // Draw facing direction
    draw_set_color(c_white);
    var line_len = tile_size * 2;
    switch (player_facing) {
        case 0: draw_point(center_x+1, center_y); break;
        case 1: draw_point(center_x+2, center_y+1); break;
        case 2: draw_point(center_x+1, center_y+2); break;
        case 3: draw_point(center_x, center_y+1); break;
    }

    draw_set_alpha(1);
}


