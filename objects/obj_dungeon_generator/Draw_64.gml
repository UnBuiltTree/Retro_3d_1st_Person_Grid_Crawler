if (keyboard_check_pressed(ord("B"))) {
    dbe_view_toggle = !dbe_view_toggle;
} // temp debugging

if dbe_view_toggle {
	draw_room_debug_view(dungeon_rooms, room_width/2, room_height/2)
}