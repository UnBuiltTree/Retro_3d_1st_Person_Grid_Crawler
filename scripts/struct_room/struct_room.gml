// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function struct_room(room_id, x_center, y_center, room_w, room_h) constructor 
{
	id = room_id
	x = x_center
	y = y_center
	width = room_w
	height = room_h
	connected_rooms = ds_list_create()
	
	clear = function(){
		ds_list_destroy(connected_rooms)
		connected_rooms = undefined
	}
	
	closest_room = function(room_list, room_id) {
	    var nRooms = ds_list_size(room_list)
	    //if (nRooms < 2) return undefined; // No other room to compare

	    var closest_id = undefined
	    var best_dist = infinity

	    for (var i = 0; i < nRooms; i++) {
			// get room
			var i_room = ds_list_find_value(room_list, room_id);
	        if (i_room == undefined or i_room.id == id) continue;


			var dist = point_distance(i_room.x, i_room.y, x, y)
	        if (dist < best_dist) {
	            best_dist = dist
	            closest_id = i_room.id
	        }
	    }
	    return closest_id
	}
	
	get_bounds = function(){
		return {
			left   : x - floor(width / 2),
		    right  : x + ceil(width / 2),
		    top    : y - floor(height / 2),
		    bottom : y + ceil(height / 2),
		}
	}
}

