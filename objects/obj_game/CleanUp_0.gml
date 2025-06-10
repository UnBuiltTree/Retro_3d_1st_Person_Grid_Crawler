
// Free rendering surfaces
if (surface_exists(texd_surface_current)) surface_free(texd_surface_current);
if (surface_exists(texd_surface_from   )) surface_free(texd_surface_from);
if (surface_exists(texd_surface_to     )) surface_free(texd_surface_to);

/*
if (variable_global_exists("tile_definitions") && ds_exists(global.tile_definitions, ds_type_map))
{
    // “Door” map
    if (ds_map_exists(global.tile_definitions, global.TILE_DOOR)) {
        var _door_map = ds_map_find_value(global.tile_definitions, global.TILE_DOOR);
        if (ds_exists(_door_map, ds_type_map)) {
            ds_map_destroy(_door_map);
        }
    }
    // “Void” map
    if (ds_map_exists(global.tile_definitions, global.TILE_VOID)) {
        var _void_map = ds_map_find_value(global.tile_definitions, global.TILE_VOID);
        if (ds_exists(_void_map, ds_type_map)) {
            ds_map_destroy(_void_map);
        }
    }
    // “Wall” map
    if (ds_map_exists(global.tile_definitions, global.TILE_WALL)) {
        var _wall_map = ds_map_find_value(global.tile_definitions, global.TILE_WALL);
        if (ds_exists(_wall_map, ds_type_map)) {
            ds_map_destroy(_wall_map);
        }
    }
    // “Room” (floor) map
    if (ds_map_exists(global.tile_definitions, global.TILE_ROOM)) {
        var _room_map = ds_map_find_value(global.tile_definitions, global.TILE_ROOM);
        if (ds_exists(_room_map, ds_type_map)) {
            ds_map_destroy(_room_map);
        }
    }
    ds_map_destroy(global.tile_definitions);
}

global.tile_definitions = undefined;

// Destroy global.main_grid
if (variable_global_exists("main_grid")) {
    if (ds_exists(global.main_grid, ds_type_grid)) {
        ds_grid_destroy(global.main_grid);
    }
}*/

//global.main_grid = undefined;
