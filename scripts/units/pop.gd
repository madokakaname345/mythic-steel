class_name Pop
extends RefCounted  # Pure data, no scene

#either city or unit
var assignment
var job
var residence

var name: String
var owner_id: int

var race
var culture
var religion

var basic_needs = {
	"food": 1,
}

var basic_needs_progress
var basic_needs_progress_max = 10

func _init():
	basic_needs_progress = 5
	self.owner_id = 1
	self.race = "Human"
	self.culture = "European"
	SignalBus.pop_created.emit(self)

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
