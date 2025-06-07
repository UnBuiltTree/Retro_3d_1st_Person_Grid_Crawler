//Ensure the “current” surface exists
if (!surface_exists(texd_surface_current)) {
    if (texd_surface_current != -1) surface_free(texd_surface_current);
    texd_surface_current = surface_create(360, 240);
}

// If we’re not turning), render one surface as usual
if (!turning) {
    draw_set_color(c_white);
    surface_set_target(texd_surface_current);
    draw_clear_alpha(c_black, 0);

    draw_textured_dungeon();

    surface_reset_target();
    
    draw_set_color(c_white);

    draw_surface_ext(
        texd_surface_current,
        0, 0,    // x,y
        1, 1,    // scale
        0,       // rot
        c_white,  // tint
        1        // alpha
    );
}
else {
    var view_w = 360;
    var offset = lerp(0, view_w * turn_direction, turn_progress);

    // Draw “from” sliding out:
    draw_set_color(c_white);
    draw_surface_ext(
        texd_surface_from,
        offset,         // as offset goes from 0 → ±320
        0,              // y
        1, 1,           // scale
        0,              // rotation
        c_white,        // no extra tint
        1               // alpha
    );

    var opposite_offset = offset - (view_w * turn_direction);
    draw_surface_ext(
        texd_surface_to,
        opposite_offset,
        0,
        1, 1,
        0,
        c_white,
        1
    );
}

draw_set_color(c_white);
if db_view_toggle {
	draw_topdown_dungeon_debug(220, 0);
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

var test = [0, 2, 3, 4]
test = array_shuffle(test)
array_foreach(test, function(value, index){ 
	draw_text(10, 40+10*index, string(value))
})