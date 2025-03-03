class_name Building

var name: String
var cost: Dictionary
var build_progress: int

# pops are assigned to these slots

# resident slots
var residents: Array
var max_residents: int

#worker slots
var workers: Array
var max_workers: int

var settlement: Settlement
var map_cell: MapCell

func _init(settlement: Settlement, map_cell: MapCell):
	self.settlement = settlement
	self.map_cell = map_cell
	
# Override in child classes
func can_be_built() -> bool:
	return true  # Default: Always valid

func on_turn_end():
	pass  # Default: No effect

func get_workers() -> Array:
	return workers

func get_max_workers() -> int:
	return max_workers

func get_residents() -> Array:
	return residents

func get_max_residents() -> int:
	return max_residents
	
func get_name():
	return name
