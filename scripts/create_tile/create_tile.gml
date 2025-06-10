// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_tile(name_str, properties) {
    var const_name = "TILE_" + string_upper(name_str);
    variable_global_set(const_name, name_str);

    // Add to tile definitions map
    ds_map_set(global.tile_definitions, name_str, properties);
}