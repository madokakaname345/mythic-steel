class_name GenericProductionOption

var name: String
var description: String
var energy_cost: int

var assigned_pop: Pop
var building: Building

func get_name():
	return name

func get_description():
	return description

func get_ui_data() -> String:
	return str("not implemented")

func assign_pop(pop: Pop):
	if pop == null:
		unassign_pop()
		return

	# check if pop can be assigned
	if pop.can_be_assigned_to(self):
		# unassign previous pop
		unassign_pop()
		self.assigned_pop = pop
		pop.assignments.append(self)

func unassign_pop():
	if assigned_pop != null:
		assigned_pop.assignments.erase(self)
		assigned_pop = null
