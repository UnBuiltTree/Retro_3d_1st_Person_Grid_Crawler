if (!surface_exists(ui_surf)) {
    ui_surf = surface_create(360, 240);
    var tex = surface_get_texture(ui_surf);
}

surface_set_target(ui_surf);
draw_clear_alpha(c_black, 0);

// --- --- Put draw stuff in here --- ---

draw_sprite_ext(spr_pov_gun, 0, display_width/2+(mouse_x_offset/4)+16, display_height+(mouse_y_offset/2), 1, 1, 0, c_white, 1)

draw_set_color(c_white);
if db_view_toggle {
	draw_topdown_dungeon_debug(room_width/2, room_height/2);
} else {
	draw_topdown_dungeon_radar(80, 40, 16)
}

if text_toggle {
	var px = 12;
	draw_set_font(fnt_debug)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	draw_text(0, px, "Press 'f11' for fullscreen,")
	draw_text(0, px*2, "'G' to regenerate level,")
	draw_text(0, px*3, "'C'/'B' to toggle debug views,")
	draw_text(0, px*4, "'V' to toggle this text.")
}
draw_set_color(c_white)
draw_set_alpha(0.6)

if hover_ui_empty { draw_set_color(c_red) } else { draw_set_color(c_white) }
draw_rectangle_bounds(ui_empty, true)

draw_set_alpha(1)

if hover_ui_knife_btn { draw_set_color(c_gray) } else { draw_set_color(c_white) }
draw_rectangle_bounds(ui_knife_button, true)
var slide_x = display_width - ui_knife_slide;
var slide_y1 = display_center - 64;
var slide_y2 = display_center + 64;


if hover_ui_knife_area { draw_set_color(c_white) } else { draw_set_color(c_gray) }
draw_rectangle(slide_x, slide_y1, display_width, slide_y2, false);

draw_set_alpha(1)

if ui_knife_slide > 0 {
	draw_sprite_ext(spr_knife, 0, slide_x+30, display_center, 2, 2, 0, c_white, 1)
}

draw_set_alpha(1)

if hover_ui_movement_btn { draw_set_color(c_gray) } else { draw_set_color(c_white) }
draw_rectangle_bounds(ui_movement_button, true)
var movement_slide_y = display_height - ui_movement_slide;
var movement_slide_x1 = display_middle-128;
var movement_slide_x2 = display_middle+128;


if hover_ui_movement_area { draw_set_color(c_white) } else { draw_set_color(c_gray) }
draw_rectangle(movement_slide_x1, display_height, movement_slide_x2, movement_slide_y, false);

draw_set_alpha(1)
draw_set_color(c_white)
if (mouse_check_button(mb_left)) {
	draw_set_color(c_red)
} else if (mouse_check_button(mb_right)) {
	draw_set_color(c_blue)
}
draw_point(mouse_x, mouse_y)
draw_circle(mouse_x-0.5, mouse_y-0.5, 3, true)
draw_set_color(c_white)

for (var i = 0; i < wave_lenth; ++i) {
	var _x = i * spacing;
	
	var y_offset = ecg_array[i]
	var y_offset_prev = y_offset
	if (i > 0 && ecg_array[i - 1] != undefined) {
		y_offset_prev = ecg_array[i-1]
	}
	
	/*
	draw_set_color(c_black)
	
	draw_line(_x, display_height/2-44, _x, display_height/2-76)
	
	draw_set_color(c_red)
	
	draw_point(_x, display_height/2-64 + y_offset)
	*/
	draw_set_color(c_lime)
	//draw_line(_x, display_height/2-64 - y_offset, _x - spacing, display_height/2-64 - y_offset_prev)
	
	draw_line(_x, display_height/2-64 - y_offset, _x, display_height/2-64 - y_offset*0.5)
	
}


// --- --- End drawing on UI --- ---

surface_reset_target();

draw_surface(
    ui_surf,
    0, 0
);