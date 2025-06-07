// If we are mid‐turning, just advance and return
if (turning) {
    turn_progress += turn_speed / turn_delay;

    if (turn_progress >= 1.0) {
        // Snap exactly to the new facing
        player_facing = turn_target_facing;
        
        // Free the old surface:
        if (surface_exists(texd_surface_from)) {
            surface_free(texd_surface_from);
        }

        // Move the 'to' surface into 'current' permanently
        if (surface_exists(texd_surface_current)) {
		    surface_free(texd_surface_current);
		}
        texd_surface_current = texd_surface_to;

        texd_surface_from	= -1;
        texd_surface_to     = -1;
        turning             = false;
        turn_progress       = 0;
        turn_direction      = 0;
    }
	
	// While turning, do not process any other movement or rotation:
    return;
}

if (!moving) {
	// Decrement move_cooldown as usual:
    if (move_cooldown > 0) {
        move_cooldown -= 1;
    }
	var new_facing = 0
    if (move_cooldown <= 0) {
		var dir = 0
        // Check for turn‐left/right
        if (keyboard_check_pressed(ord("A"))) {
            new_facing = (player_facing + 3) mod 4;
            dir = -1; // left
        }
        else if (keyboard_check_pressed(ord("D"))) {
            new_facing = (player_facing + 1) mod 4;
            dir = +1; // right
        }
        else {
            new_facing = noone;
        }

        if (new_facing != noone) {
            if (surface_exists(texd_surface_from)) {
                surface_free(texd_surface_from);
            }
            // Create a “from” surface to freeze current view
            texd_surface_from = surface_create(360, 240);
            surface_set_target(texd_surface_from);
            draw_clear_alpha(c_black, 0);
            draw_surface(texd_surface_current, 0, 0);
            surface_reset_target();

            if (surface_exists(texd_surface_to)) {
                surface_free(texd_surface_to);
            }
            texd_surface_to = surface_create(360, 240);

            var old_facing = player_facing;
            player_facing  = new_facing;

            draw_set_color(c_white);
            surface_set_target(texd_surface_to);
            draw_clear_alpha(c_black, 0);
            draw_textured_dungeon();
            surface_reset_target();

            player_facing      = old_facing;
            turn_direction     = -dir;
            turn_target_facing = new_facing;
            turn_progress      = 0;
            turning            = true;

            move_cooldown = turn_delay;
            return;
        }
    }

    // Movement: forward/backward
    if (move_cooldown <= 0) {
        var new_x, new_y;

        if (keyboard_check_pressed(ord("W"))) {
            new_x = player_x + dx[player_facing];
            new_y = player_y + dy[player_facing];

            // Convert to grid‐indices
            var gx = new_x + global.MAP_OFFSET_X;
            var gy = new_y + global.MAP_OFFSET_Y;

            if (gx >= 0 && gx < ds_grid_width(global.main_grid)
             && gy >= 0 && gy < ds_grid_height(global.main_grid))
            {
                var next_tile_key = ds_grid_get(global.main_grid, gx, gy);
                var next_info     = ds_map_find_value(global.tile_definitions, next_tile_key);

                if (next_info != undefined 
                 && !ds_map_find_value(next_info, "is_wall"))
                {
                    player_real_x = player_x;
                    player_real_y = player_y;
                    move_start_x  = player_x;
                    move_start_y  = player_y;
                    move_target_x = new_x;
                    move_target_y = new_y;
                    move_progress = 0;
                    moving        = true;
                }
            }
        }

        // Move Backward
        else if (keyboard_check_pressed(ord("S"))) {
            new_x = player_x - dx[player_facing];
            new_y = player_y - dy[player_facing];

            // Convert to grid‐indices
            var gx = new_x + global.MAP_OFFSET_X;
            var gy = new_y + global.MAP_OFFSET_Y;

            if (gx >= 0 && gx < ds_grid_width(global.main_grid)
             && gy >= 0 && gy < ds_grid_height(global.main_grid))
            {
                var prev_tile_key = ds_grid_get(global.main_grid, gx, gy);
                var prev_info     = ds_map_find_value(global.tile_definitions, prev_tile_key);

                if (prev_info != undefined 
                 && !ds_map_find_value(prev_info, "is_wall"))
                {
                    player_real_x = player_x;
                    player_real_y = player_y;
                    move_start_x  = player_x;
                    move_start_y  = player_y;
                    move_target_x = new_x;
                    move_target_y = new_y;
                    move_progress = 0;
                    moving        = true;
                }
            }
        }
    }


    if (!moving) {
        player_real_x = player_x;
        player_real_y = player_y;
    }
}
else {
    move_progress += turn_speed / move_delay;

    if (move_progress >= 1.0) {
        player_x      = move_target_x;
        player_y      = move_target_y;
        moving        = false;
        move_progress = 0;
        move_cooldown = move_delay;

        player_real_x = player_x;
        player_real_y = player_y;
    } 
    else {
        player_real_x = lerp(move_start_x, move_target_x, move_progress);
        player_real_y = lerp(move_start_y, move_target_y, move_progress);
    }
}

// Fullscreen toggle
if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}

if (keyboard_check_pressed(ord("G"))) {
    room_goto(rm_game);
}

if (keyboard_check_pressed(ord("V"))) {
    text_toggle = !text_toggle;
}
if (keyboard_check_pressed(ord("C"))) {
    db_view_toggle = !db_view_toggle;
}
