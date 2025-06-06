if (is_undefined(dungeon_rooms)) return;

// Destroy all room maps and their inner connected room lists
var _n = ds_list_size(dungeon_rooms);
for (var i = 0; i < _n; i++) {
    var _room = ds_list_find_value(dungeon_rooms, i);

    // Destroy connected_rooms list
    if (ds_map_exists(_room, "connected_rooms")) {
        var _conn = ds_map_find_value(_room, "connected_rooms");
        if (ds_exists(_conn, ds_type_list)) {
            ds_list_destroy(_conn);
        }
    }

    if (ds_exists(_room, ds_type_map)) {
        ds_map_destroy(_room);
    }
}

// Destroy the main list
ds_list_destroy(dungeon_rooms);
