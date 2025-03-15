class_name GenericProductionOption

var name: String
var description: String

var assigned_pop: Pop
var building: Building

func get_name():
	return name

func get_description():
	return description

func get_ui_data() -> String:
	return str("not implemented")

func assign_pop(pop: Pop):
	# unassign previous pop
	if assigned_pop != null:
		assigned_pop.assignment = null
		
	self.assigned_pop = pop
	
	if pop != null:
		pop.assignment = self
