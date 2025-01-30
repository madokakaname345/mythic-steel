class_name Settlement


var name
var population
var food
var buildings

var atlas_mapping = Vector2i(0, 3)

func _init(name: String):
	self.name = name
	self.population = 1
	self.food = 10
	SignalBus.settlement_created.emit(self)

func end_turn():
	#calc food
	food += 1
	if food > 10:
		food = 5
		population += 1
		print("pop growth")
	print("settlement turn ended")
