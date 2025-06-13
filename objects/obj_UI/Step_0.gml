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