// 360 × 240 UI buffer
ui_surf = surface_create(display_width, display_height);
if (surface_exists(ui_surf)) {
    var ui_tex = surface_get_texture(ui_surf);
}
display_middle = display_width/2
display_center = display_height/2

text_toggle = true;
db_view_toggle = false;

hover_ui_empty = false;
ui_empty = [64, 64, display_width-64, display_height-64]

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

ui_movement_button = [display_middle+32, display_height, display_middle-32, display_height-16]
ui_movement_area = [display_middle+128, display_height, display_middle-128, display_height-32]
