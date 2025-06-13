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

// Reset hovers
hover_ui_empty = false;
hover_ui_knife_btn = false;
hover_ui_knife_area = false;
hover_ui_movement_btn = false;
hover_ui_movement_area = false;

// Detect hover states
if (mouse_in_bounds(ui_empty)) {
	hover_ui_empty = true;
} else {
	if (mouse_in_bounds(ui_knife_button)) {
		hover_ui_knife_btn = true;
	}
	if (mouse_in_bounds(ui_knife_area)) {
		hover_ui_knife_area = true;
	}
	if (mouse_in_bounds(ui_movement_button)) {
		hover_ui_movement_btn = true;
	}
	if (mouse_in_bounds(ui_movement_area)) {
		hover_ui_movement_area = true;
	}
}

// Determine target state
if (hover_ui_knife_btn || hover_ui_knife_area) {
	ui_knife_slide_target = ui_knife_slide_dist;
} else {
	ui_knife_slide_target = 0;
}

if (ui_knife_slide < ui_knife_slide_target) {
	ui_knife_slide = min(ui_knife_slide + ui_knife_slide_speed, ui_knife_slide_target);
} else if (ui_knife_slide > ui_knife_slide_target) {
	ui_knife_slide = max(ui_knife_slide - ui_knife_slide_speed, ui_knife_slide_target);
}

// Determine target state
if (hover_ui_movement_btn || hover_ui_movement_area) {
	ui_movement_slide_target = ui_movement_slide_dist;
} else {
	ui_movement_slide_target = 0;
}

if (ui_movement_slide < ui_movement_slide_target) {
	ui_movement_slide = min(ui_movement_slide + ui_movement_slide_speed, ui_movement_slide_target);
} else if (ui_movement_slide > ui_movement_slide_target) {
	ui_movement_slide = max(ui_movement_slide - ui_movement_slide_speed, ui_movement_slide_target);
}

