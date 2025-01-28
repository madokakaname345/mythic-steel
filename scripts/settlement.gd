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
