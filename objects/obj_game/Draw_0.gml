
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
    var _color = c_white;
    if (keyboard_check(ord("X")))      _color = c_red;
    else if (keyboard_check(ord("V"))) _color = c_blue;
    else if (keyboard_check(ord("Z"))) _color = c_dkgray;

    draw_surface_ext(
        texd_surface_current,
        0, 0,    // x,y
        1, 1,    // scale
        0,       // rot
        _color,  // tint
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
draw_topdown_dungeon(220, 0);
