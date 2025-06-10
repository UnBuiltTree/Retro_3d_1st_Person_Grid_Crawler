if(instance_number(obj_dungeon_generator) > 1){
	throw("obj_dungeon_generator is a singleton!")
}

// Reset main grid
ds_grid_clear(global.main_grid, global.TILE_VOID)

// spawn room parameters
var spawn_room_width  = 12;
var spawn_room_height = 12;
var spawn_room_x = global.MAP_OFFSET_X;
var spawn_room_y = global.MAP_OFFSET_Y;

dungeon_rooms = ds_list_create();

// Create the spawn room
create_room(
    global.main_grid,
    dungeon_rooms,
    0,					// room_id
    spawn_room_x,		// x_center
    spawn_room_y,		// y_center
    spawn_room_width,	// width
    spawn_room_height	// height
);
render_room_blob(
    global.main_grid,
    ds_list_find_value(dungeon_rooms, 0)
);

var pending_connections = ds_list_create();

var last_index = 0;

//generate dungeon rooms
for (var i = 1; i < 42; ++i) {
    var _room_width  = irandom_range(round(3 + (i / 8)), round(7 + (i / 4)));
    if (_room_width mod 2 == 0) _room_width++;

    var _room_height = irandom_range(round(3 + (i / 8)), round(7 + (i / 4)));
    if (_room_height mod 2 == 0) _room_height++;

    var closeness = irandom_range(1, round(1 + (i / 4)));
	var choas = 12

    var new_room = find_room_place(
        global.main_grid,
        dungeon_rooms,
        _room_width,
        _room_height,
        closeness,
		choas
    );
    if (new_room == undefined) {
        show_debug_message("Could not place room " + string(i));
        continue;
    }
	var new_index = ds_list_size(dungeon_rooms) - 1
	new_room[$ "id"] = new_index
	ds_list_add(dungeon_rooms, new_room);

	var _blob = choose(0,1)
	if _blob {
    render_room_blob(
        global.main_grid,
        ds_list_find_value(dungeon_rooms, new_index)
    );
	} else {
		render_room(
        global.main_grid,
        ds_list_find_value(dungeon_rooms, new_index)
		);
		last_room = ds_list_find_value(dungeon_rooms, ds_list_size(dungeon_rooms) - 1);
	}

    var nearest = closest_room(dungeon_rooms, new_index);
    if (nearest != undefined) {
        // Store the connection [from_index, to_index]
        var conn = [ new_index, nearest ];
        ds_list_add(pending_connections, conn);
    }
}

// After placement loop, carve corridors for all stored connections
var _pc_count = ds_list_size(pending_connections);
for (var j = 0; j < _pc_count; j++) {
    var conn = pending_connections[| j];
    var from_idx = conn[0];
    var to_idx   = conn[1];
    connect_rooms(
        global.main_grid,
        dungeon_rooms,
        from_idx,
        to_idx
    );
}
ds_list_destroy(pending_connections);


for (var i = 0; i < ds_list_size(dungeon_rooms); i++) {
    var _room = ds_list_find_value(dungeon_rooms, i);

    place_doors(global.main_grid, _room);
}


global.spawn_x = 0
global.spawn_y = 0

var last_room_center = get_room_center(dungeon_rooms, last_room);
if (last_room != undefined) {
    var _x_center = ds_map_find_value(last_room, "_x");
    var _y_center = ds_map_find_value(last_room, "_y");

    show_debug_message("Center of room: (" + string(_x_center) + ", " + string(_y_center) + ")");
    global.spawn_x = _x_center - global.MAP_OFFSET_X;
    global.spawn_y = _y_center - global.MAP_OFFSET_Y;
}

instance_destroy();
