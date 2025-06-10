if (is_undefined(dungeon_rooms)) return;

// Destroy all room maps and their inner connected room lists
var _n = ds_list_size(dungeon_rooms);
for (var i = 0; i < _n; i++) {
    var _room = ds_list_find_value(dungeon_rooms, i);
	_room.clear()
}

// Destroy the main list
ds_list_destroy(dungeon_rooms);
