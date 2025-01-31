class_name Building

var name: String
var cost: Dictionary
var workers_required: int
var settlement: Settlement

func _init(settlement: Settlement):
	self.settlement = settlement

# Override in child classes
func can_be_built() -> bool:
	return true  # Default: Always valid

func on_turn_end():
	pass  # Default: No effect
