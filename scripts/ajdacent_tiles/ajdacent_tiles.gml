// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function adjacent_tiles(_gx, _gy){
	return {
		top    : global.main_grid[# _gx  , _gy-1],
		bottom : global.main_grid[# _gx  , _gy+1],
		left   : global.main_grid[# _gx-1, _gy  ],
		right  : global.main_grid[# _gx+1, _gy  ],
	}
}