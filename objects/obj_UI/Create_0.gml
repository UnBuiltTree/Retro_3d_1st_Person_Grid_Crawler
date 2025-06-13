// 360 × 240 UI buffer
ui_surf = surface_create(display_width, display_height);
if (surface_exists(ui_surf)) {
    var ui_tex = surface_get_texture(ui_surf);
}

text_toggle = true;
db_view_toggle = false;