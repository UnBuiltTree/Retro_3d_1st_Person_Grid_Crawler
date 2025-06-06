texd_surface_current = -1;

max_depth = 7;

move_cooldown = 0;

dx = [0, 1, 0, -1];       // North, East, South, West
dy = [-1, 0, 1, 0];

player_x       = 2.0;
player_y       = 2.0;
player_facing  = 0;


player_real_x  = player_x;
player_real_y  = player_y;

turn_speed		= 0.5;
moving			= false;  // are we currently sliding between two cells?
move_progress	= 0;      // goes from 0.0 → 1.0 over move_delay frames
move_delay		= 8;


turn_speed		= 0.75;
turning			= false; // are we currently turning ?
turn_progress	= 0;		//goes from 0 → 1 over `turn_delay` frames.
turn_delay		= 8; 
player_angle	= 0;
turn_direction	= 0;


move_start_x	= player_real_x;
move_start_y	= player_real_y;
move_target_x	= player_real_x;
move_target_y	= player_real_y;

turn_target_facing	= player_facing;

texd_surface_from	= -1;   // the old orientation
texd_surface_to	= -1;   // the new orientation


// Sample map
global.map = [
	[1,1,1,1,1,1,1],
	[1,0,0,0,1,0,1],
	[1,0,0,0,0,0,1],
	[1,0,0,0,1,0,1],
	[1,1,0,1,1,0,1],
	[1,0,0,0,1,0,1],
	[1,0,1,0,1,0,1],
	[1,0,0,0,0,0,1],
	[1,1,1,1,1,1,1],
];
