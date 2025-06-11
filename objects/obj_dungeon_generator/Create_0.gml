if(instance_number(obj_dungeon_generator) > 1){
	throw("obj_dungeon_generator is a singleton!")
}

dbe_view_toggle = 1;

// Reset main grid
ds_grid_clear(global.main_grid, global.TILE_VOID)

// spawn room parameters
var spawn_room_width  = 12;
var spawn_room_height = 12;
var spawn_room_x = global.MAP_OFFSET_X;
var spawn_room_y = global.MAP_OFFSET_Y;

dungeon_rooms = ds_list_create();

var spawn_room = new struct_room(0, spawn_room_x, spawn_room_y, spawn_room_width, spawn_room_height)
ds_list_add(dungeon_rooms, spawn_room);

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

    var closeness = 3;
	var choas = 10;

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
	var new_index = ds_list_size(dungeon_rooms)
	new_room[$ "id"] = new_index
	ds_list_add(dungeon_rooms, new_room);
	var _blob = choose(0, 1)
	if _blob == 1 {
    render_room_blob(
        global.main_grid,
        ds_list_find_value(dungeon_rooms, new_index)
    );
	} else {
		render_room(
        global.main_grid,
        ds_list_find_value(dungeon_rooms, new_index)
		);
		last_room = ds_list_find_value(dungeon_rooms, ds_list_size(dungeon_rooms) - 1); // Does size change?
	}

	// var nearest = closest_room(dungeon_rooms, new_index);
	var nearest = new_room.closest_room(dungeon_rooms)
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
        dungeon_rooms,
        from_idx,
        to_idx
    );
}

for (var j = 0; j < ds_list_size(pending_connections); j++) {
    var conn = pending_connections[| j];
    var from_idx = conn[0];
    var to_idx   = conn[1];

    var room1 = ds_list_find_value(dungeon_rooms, from_idx);
    var room2 = ds_list_find_value(dungeon_rooms, to_idx);

    if (room1 != undefined && room2 != undefined) {
        create_connection(global.main_grid, room1, room2);
    }
}

// Extra connection for the depressed and lonely outer rooms
ds_list_clear(pending_connections);
for (var i = 0; i < ds_list_size(dungeon_rooms); i++) {
	var room_ = ds_list_find_value(dungeon_rooms, i);

	if (room_ != undefined && ds_list_size(room_.connected_rooms) == 1) {
		var sorted_rooms = room_.rooms_sorted_by_distance(dungeon_rooms);

		// Skip if less than 2 candidates
		if (ds_list_size(sorted_rooms) < 2) continue;

		// Second closest room (index 1, since index 0 is the closest)
		var second_closest = ds_list_find_value(sorted_rooms, 1);

		if (second_closest != undefined) {
			var conn = [ room_.id, second_closest.id ];
			ds_list_add(pending_connections, conn);
			 connect_rooms(
		        dungeon_rooms,
		        room_.id,
		        second_closest.id
		    );
		}
		ds_list_destroy(sorted_rooms);
	}
}

_pc_count = ds_list_size(pending_connections);
for (var j = 0; j < _pc_count; j++) {
    var conn = pending_connections[| j];
    var from_idx = conn[0];
    var to_idx   = conn[1];
	var room1 = ds_list_find_value(dungeon_rooms, from_idx);
    var room2 = ds_list_find_value(dungeon_rooms, to_idx);
	if point_distance(room1.x, room1.y, room2.x, room2.y) < grid_size/1.5 {
	    connect_rooms(
	        dungeon_rooms,
	        from_idx,
	        to_idx
	    );
	}
}

for (var j = 0; j < ds_list_size(pending_connections); j++) {
    var conn = pending_connections[| j];
    var from_idx = conn[0];
    var to_idx   = conn[1];

    var room1 = ds_list_find_value(dungeon_rooms, from_idx);
    var room2 = ds_list_find_value(dungeon_rooms, to_idx);

    if (room1 != undefined && room2 != undefined) {
        create_connection(global.main_grid, room1, room2);
    }
}

ds_list_destroy(pending_connections);

/*
for (var i = 0; i < ds_list_size(dungeon_rooms); i++) {
    var _room = ds_list_find_value(dungeon_rooms, i);

    place_doors(global.main_grid, _room);
}*/


global.spawn_x = 0
global.spawn_y = 0

if (last_room != undefined) {
    var _x_center = last_room.x;
    var _y_center = last_room.y;

    show_debug_message("Center of room: (" + string(_x_center) + ", " + string(_y_center) + ")");
    global.spawn_x = _x_center - global.MAP_OFFSET_X;
    global.spawn_y = _y_center - global.MAP_OFFSET_Y;
}
