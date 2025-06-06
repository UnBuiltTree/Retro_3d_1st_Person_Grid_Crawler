

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
        texd_surface_current = texd_surface_to;

        texd_surface_from	= -1;
        texd_surface_to		= -1;
        turning				= false;
        turn_progress		= 0;
        turn_direction		= 0;
    }
	
	// While turning, do not process any other movement or rotation:
    return;
}

if (!moving) {
	// Decrement move_cooldown as usual:
    if (move_cooldown > 0) {
        move_cooldown -= 1;
    }

    if (move_cooldown <= 0) {
        if (keyboard_check_pressed(ord("A"))) {
            var new_facing = (player_facing + 3) mod 4;
            var dir = -1; // left
        }
        else if (keyboard_check_pressed(ord("D"))) {
            var new_facing = (player_facing + 1) mod 4;
            var dir = +1; // right
        }
        else {
            var new_facing = noone;
        }

        if (new_facing != noone) {
            if (surface_exists(texd_surface_from)) {
                surface_free(texd_surface_from);
            }
			// Create a new surface the same size as current
            texd_surface_from = surface_create(360, 240);
            surface_set_target(texd_surface_from);
			// Draw the old view exactly as is
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

            player_facing	= old_facing;

            turn_direction		= -dir;
            turn_target_facing	= new_facing;
            turn_progress		= 0;
            turning				= true;

            move_cooldown = turn_delay;
			
            return;
        }
    }

    if (move_cooldown <= 0) {
        var new_x, new_y;

        // Move Forward
        if (keyboard_check_pressed(ord("W"))) {
            new_x = player_x + dx[player_facing];
            new_y = player_y + dy[player_facing];

            if (new_x >= 0 && new_x < ds_grid_width(global.map_grid)
             && new_y >= 0 && new_y < ds_grid_height(global.map_grid))
            {
                // Get the tile key at the target cell
                var next_tile_key = ds_grid_get(global.map_grid, new_x, new_y);
                // Lookup its info map in tile_definitions
                var next_info     = ds_map_find_value(tile_definitions, next_tile_key);
                
                // Only move if the tile exists and is not a wall
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

            if (new_x >= 0 && new_x < ds_grid_width(global.map_grid)
             && new_y >= 0 && new_y < ds_grid_height(global.map_grid))
            {
                var prev_tile_key = ds_grid_get(global.map_grid, new_x, new_y);
                var prev_info     = ds_map_find_value(tile_definitions, prev_tile_key);

                // Only move if the tile exists and is not a wall
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
