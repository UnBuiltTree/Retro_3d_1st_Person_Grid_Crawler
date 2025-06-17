// 360 × 240 UI buffer
ui_surf = surface_create(display_width, display_height);
if (surface_exists(ui_surf)) {
    var ui_tex = surface_get_texture(ui_surf);
}

window_set_cursor(cr_none);

display_middle = display_width/2
display_center = display_height/2

text_toggle = true;
db_view_toggle = false;

hover_ui_empty = false;
ui_empty = [64, 64, display_width-64, display_height-64]


raw_x = mouse_x - display_middle;
raw_y = mouse_y - display_center;
mouse_offset_target_x = 0;
mouse_offset_target_y = 0;
mouse_x_offset = 0;
mouse_y_offset = 0;
smooth_factor = 0.15;

// ui_name_area for a detecable area on the ui
// ui_name_btn for a button on the ui

hover_ui_knife_btn = false;
hover_ui_knife_area = false;
ui_knife_slide = 0;
ui_knife_slide_dist = 48;
ui_knife_slide_target = 0;
ui_knife_slide_speed = 6; // pixels per frame

ui_knife_button = [display_width, (display_center)+32, display_width-32, (display_center)-32]
ui_knife_area = [display_width, (display_center)+64, display_width-64, (display_center)-64]



hover_ui_movement_btn = false;
hover_ui_movement_area = false;
ui_movement_slide = 0;
ui_movement_slide_dist = 32;
ui_movement_slide_target = 0;
ui_movement_slide_speed = 6; // pixels per frame

ui_movement_button = [display_middle+32, display_height, display_middle-32, display_height-16];
ui_movement_area = [display_middle+128, display_height, display_middle-128, display_height-32];

phase = 0;
ecg_array = [];

wave_lenth = 32;
spacing = 1;
amplitude = 16;
frequency = 1;
rate = 0.1

beep_cooldown = 0;

function simulated_ecg(length, amplitude, frequency, offset) {
	var result = array_create(length, 0);
	for (var i = 0; i < length; ++i) {
		//var angle = (i/ length) * frequency * 2 * pi + offset;
		var t = (i/ length) * frequency * 2 * pi + offset 
	    var phase = 2.0 * cos ( t )
	    var r_wave = -sin ( t + phase )
	    var q_scalar = 0.50 - 0.75 * sin ( t - 1.0 )
	    var s_scalar = 0.25 - 0.125 * sin ( 1.25 * phase - 1.0 )
		result[i] = (pi * q_scalar * r_wave * s_scalar)*amplitude;
	}
	return result;
}
