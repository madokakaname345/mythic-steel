class_name WorldMap

var width
var height
var cells = []

func _init(width, height):
	self.width = width
	self.height = height
	self.cells.resize(width * height)

func set_cell(x, y, cell):
	var index = y * width + x
	cells[index] = cell

func get_cell(x, y):
	var index = y * width + x
	return cells[index]
