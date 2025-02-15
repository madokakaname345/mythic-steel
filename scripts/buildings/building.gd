class_name Building

var name: String
var cost: Dictionary
var build_progress: int

# pops are assigned to these slots
#var residents: Array
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
