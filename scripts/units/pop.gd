class_name Pop
extends RefCounted  # Pure data, no scene

#either city or unit
var assignments: Array[GenericProductionOption]
var job
var residence

var name: String
var owner_id: int

var available_names = ["John", "Joe", "Gandon"]

var available_surnames = ["Johnson", "Gandonov", "Ivanov"]

var race
var culture
var religion

var max_energy = 5

var haul_reserved_energy = 0

var main: Main

var basic_needs = {
	"food": 1,
}

var basic_needs_progress
var basic_needs_progress_max = 10

func _init(main: Main):
	self.main = main
	basic_needs_progress = 5
	self.owner_id = 1
	self.race = "Human"
	self.culture = "European"
	SignalBus.pop_created.emit(self)
	self.name = str("%s %s" % [available_names.pick_random(), available_surnames.pick_random()])

# in future calculate it using race + culture + religion + events etc
func get_productivity() -> Dictionary:
	return {
			Consts.LOWER_CLASS: {
			ResourceTypes.PRODUCTION_TYPE.MANUAL_LABOR : 3,
			ResourceTypes.PRODUCTION_TYPE.AGRICULTURE : 2,
		},
	}

# in future calculate it using race + culture + religion + events etc
func get_production_capacity() -> Dictionary:
	return {
			Consts.LOWER_CLASS: 3,
	}

# in future calculate it using race + culture + religion + events etc
func get_needs() -> Dictionary:
	return {
			Consts.LOWER_CLASS: {
			Consts.FOOD : 1,
		},
	}

func get_assignment_group() -> String:
	return self.race + " " + self.culture 

func get_basic_info() -> String:
	var assignment_ui = "no assignment"
	if assignments != null and assignments.size() > 0:
		assignment_ui = assignments[0].get_name() 
		return str("name: %s, assignments: %s..." % [name, assignment_ui])
	elif assignments.size() == 1:
		assignment_ui = assignments[0].get_name() 
		return str("name: %s, assignments: %s..." % [name, assignment_ui])
	return assignment_ui


func can_be_assigned_to(production_option: GenericProductionOption) -> bool:
	# check not assigned to this prod option already
	if assignments.has(production_option):
		return false

	if production_option.energy_cost > get_remaining_energy():
		return false

	return true


func get_remaining_energy() -> int:
	var curr_energy_consumption = 0

	for assignment in assignments:
		curr_energy_consumption += assignment.energy_cost

	return max_energy - curr_energy_consumption

func calc_required_energy_to_haul(res_type: String, distance: int, amount: int) -> int:
	return distance * amount * main.get_res_info(res_type)["weight"]
