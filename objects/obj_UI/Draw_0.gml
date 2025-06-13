if (!surface_exists(ui_surf)) {
    ui_surf = surface_create(360, 240);
    var tex = surface_get_texture(ui_surf);
}

surface_set_target(ui_surf);
draw_clear_alpha(c_black, 0);

// --- --- Put draw stuff in here --- ---

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
	draw_text(0, px*3, "'C' to toggle debug view,")
	draw_text(0, px*4, "'V' to toggle this text.")
}

// --- --- End drawing on UI --- ---

surface_reset_target();

draw_surface(
    ui_surf,
    0, 0
);