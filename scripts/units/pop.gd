class_name Pop
extends RefCounted  # Pure data, no scene

#either city or unit
var assignment
var job
var residence

var name: String
var owner_id: int

var culture
var religion

var basic_needs = {
	"food": 1,
}

var basic_needs_progress
var basic_needs_progress_max = 10

func _init(location):
	basic_needs_progress = 5
	self.assignment = location
	self.owner_id = 1
	SignalBus.pop_created.emit(self)
