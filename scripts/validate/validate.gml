function val_grid_size(value){
	// Handle: Not a number
	if !is_real(value) {
		throw ($"Value: {value} is not an number")
	}
	
	// Handle: Is float, not integer
	if round(value) != value {
		throw ($"Value: {value} is not an integer")
	}
	
	// Handle: Is not in area
	if(value < 0 or value >= grid_size){
		throw ($"Value: {value} out of bounds of grid size")
	}
}