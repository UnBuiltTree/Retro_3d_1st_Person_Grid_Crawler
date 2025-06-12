if (move_cooldown > 0) move_cooldown--;

// turning
if (turn_progress == 0) {
    if (keyboard_check(ord("A"))) {
        turning			= true;
        turn_progress	= 1;
        turn_from_angle	= player_angle;
        turn_to_angle	= (player_angle + 45) mod 360;
    }
    else if (keyboard_check(ord("D"))) {
        turning			= true;
        turn_progress	= 1;
        turn_from_angle	= player_angle;
        turn_to_angle	= (player_angle - 45 + 360) mod 360;
    }
} else {
    turn_progress++;
    var t = clamp(turn_progress / turn_duration, 0, 1);
    var delta = ((turn_to_angle - turn_from_angle + 540) mod 360) - 180;
    player_angle = (turn_from_angle + delta * t + 360) mod 360;

    if (turn_progress >= turn_duration) {
        turning			= false;
        player_angle	= turn_to_angle;
        move_cooldown	= move_cooldown_max;
    }
	if turn_progress == turn_duration {
		turn_progress = 0;
	}
}

// movement
if (moving) {
    move_progress++;
    var t = clamp(move_progress / move_duration, 0, 1);
    player_real_x = lerp(move_start_x, move_target_x, t);
    player_real_y = lerp(move_start_y, move_target_y, t);

    if (move_progress >= move_duration) {
        moving         = false;
        player_x       = move_target_x;
        player_y       = move_target_y;
        move_cooldown  = move_cooldown_max;
    }
} else {
    if (!turning && move_cooldown == 0) {
        var dx_cell = round(lengthdir_x(1, player_angle));
        var dy_cell = round(lengthdir_y(1, player_angle));

        var try_x = player_x;
        var try_y = player_y;

        if (keyboard_check_direct(ord("W"))) {
            try_x += dx_cell;
            try_y += dy_cell;
        }
        else if (keyboard_check_direct(ord("S"))) {
            try_x -= dx_cell;
            try_y -= dy_cell;
        }

        if (try_x != player_x || try_y != player_y) {
            var gx = try_x + global.MAP_OFFSET_X;
            var gy = try_y + global.MAP_OFFSET_Y;

            if (gx >= 0 && gx < grid_size
             && gy >= 0 && gy < grid_size) 
            {
                var tile_key = global.main_grid[# gx, gy];
                var tile_info = ds_map_find_value(global.tile_definitions, tile_key);
				
				
				
                if (tile_info != undefined && tile_info.is_walkable) {
                    moving         = true;
                    move_progress  = 0;
                    move_start_x   = player_real_x;
                    move_start_y   = player_real_y;
                    move_target_x  = try_x;
                    move_target_y  = try_y;
                }
            }
        }
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

global.player_x = player_x
global.player_y = player_y
global.player_angle = player_angle


// Step Event
frame_timer++;
if (frame_timer >= frame_speed) {
    frame_timer = 0;
    global.frame = (global.frame + 1) mod 14;
}
