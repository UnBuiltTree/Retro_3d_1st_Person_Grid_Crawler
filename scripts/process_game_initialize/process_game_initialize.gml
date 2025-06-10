// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function process_game_initialize() {
	if variable_global_exists("initialized") { return false }
	
	#macro display_width 360
	#macro display_height 240
	#macro grid_size 64
	
	global.vf_wall = vertex_format_position_3d_color_texture()
	global.vf_quad = vertex_format_position_3d_color_texture()
	global.main_grid = ds_grid_create(grid_size, grid_size)
	global.MAP_OFFSET_X = grid_size / 2;
	global.MAP_OFFSET_Y = grid_size / 2;
	global.tile_definitions = ds_map_create()
	/* properties
	 sprite...		- sprites used in this tile, accending numbers
	 is_wall		- used in generation
	 is_transparent - tiles that have transparent sprites
	 is_walkable	- can the player walk on this tile?
	*/
	create_tile("room", {
	    sprite: spr_floor,
	    sprite1: spr_ceil,
	    is_wall: false,
	    is_transparent: false,
	    is_walkable: true
	})
	create_tile("wall", {
	    sprite: spr_wall,
	    is_wall: true,
	    is_transparent: false,
	    is_walkable: false
	})
	create_tile("door", {
	    sprite: spr_door_1,
	    sprite1: spr_ceil,
	    sprite2: spr_floor,
	    is_wall: false,
	    is_transparent: true,
	    is_walkable: true
	})
	create_tile("glass", {
	    sprite: spr_glass,
	    sprite1: spr_ceil,
	    sprite2: spr_floor,
	    is_wall: true,
	    is_transparent: true,
	    is_walkable: false
	})
	create_tile("void", {
	    sprite: -1,
	    is_wall: false,
	    is_transparent: false,
	    is_walkable: true // for debug
	})
	
	global.initialized = true
	return true
}