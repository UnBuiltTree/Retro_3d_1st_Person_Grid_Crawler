
global.TILE_VOID  = "void";
global.TILE_WALL  = "wall1";
global.TILE_ROOM  = "floor1";
global.TILE_DOOR  = "door1";
global.TILE_AREA  = "area";

var room_map = ds_map_create();
ds_map_add(room_map, "sprite", spr_floor);
ds_map_add(room_map, "is_wall", false);
ds_map_add(global.tile_definitions, global.TILE_ROOM, room_map);

var wall_map = ds_map_create();
ds_map_add(wall_map, "sprite", spr_wall);
ds_map_add(wall_map, "is_wall", true);
ds_map_add(global.tile_definitions, global.TILE_WALL, wall_map);

var door_map = ds_map_create();
ds_map_add(door_map, "sprite", spr_door);
ds_map_add(door_map, "is_wall", false);
ds_map_add(global.tile_definitions, global.TILE_DOOR, door_map);

var void_map = ds_map_create();
ds_map_add(void_map, "sprite", -1);
ds_map_add(void_map, "is_wall", true);
ds_map_add(global.tile_definitions, global.TILE_VOID, void_map);

var grid_size = 64;
global.main_grid = ds_grid_create(grid_size, grid_size);
for (var gx = 0; gx < grid_size; gx++) {
    for (var gy = 0; gy < grid_size; gy++) {
        ds_grid_set(global.main_grid, gx, gy, global.TILE_VOID);
    }
}

global.MAP_OFFSET_X = grid_size / 2;
global.MAP_OFFSET_Y = grid_size / 2;

// spawn room parameters
var spawn_room_width  = 5;
var spawn_room_height = 5;
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
render_room(
    global.main_grid,
    ds_list_find_value(dungeon_rooms, 0)
);

var pending_connections = ds_list_create();

//generate dungeon rooms
for (var i = 1; i < 32; ++i) {
    var _room_width  = irandom_range(round(4 + (i / 8)), round(4 + (i / 4)));
    if (_room_width mod 2 == 0) _room_width++;

    var _room_height = irandom_range(round(4 + (i / 8)), round(4 + (i / 4)));
    if (_room_height mod 2 == 0) _room_height++;

    var closeness = round(1 + (i / 8));
	var choas = round(1 + (i / 4));

    var place = find_room_place(
        global.main_grid,
        dungeon_rooms,
        _room_width,
        _room_height,
        closeness,
		choas
    );
    if (place == undefined) {
        show_debug_message("Could not place room " + string(i));
        continue;
    }

    create_room(
        global.main_grid,
        dungeon_rooms,
        i,			// room_id = i
        place[0],	// x_center
        place[1],	// y_center
        _room_width,
        _room_height
    );

    var new_index = ds_list_size(dungeon_rooms) - 1;

    render_room(
        global.main_grid,
        ds_list_find_value(dungeon_rooms, new_index)
    );

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

global.spawn_x = 0;
global.spawn_y = 0;

instance_destroy();
