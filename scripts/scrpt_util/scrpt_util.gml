function angle_wrap(angle) {
    return ((angle mod 360) + 360) mod 360;
}

function mouse_in_box(x1, y1, x2, y2) {
    var min_x = min(x1, x2);
    var max_x = max(x1, x2);
    var min_y = min(y1, y2);
    var max_y = max(y1, y2);

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    return (mx >= min_x && mx <= max_x && my >= min_y && my <= max_y);
}

function mouse_in_bounds(bounds_array) {
    var x1 = bounds_array[0];
    var y1 = bounds_array[1];
    var x2 = bounds_array[2];
    var y2 = bounds_array[3];

    var min_x = min(x1, x2);
    var max_x = max(x1, x2);
    var min_y = min(y1, y2);
    var max_y = max(y1, y2);

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    return (mx >= min_x && mx <= max_x && my >= min_y && my <= max_y);
}
	
function draw_rectangle_bounds(bounds_array, outline) {
    var x1 = bounds_array[0];
    var y1 = bounds_array[1];
    var x2 = bounds_array[2];
    var y2 = bounds_array[3];

    draw_rectangle(x1, y1, x2, y2, outline);
}