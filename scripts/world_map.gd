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

func get_cell(coords):
	var index = coords.y * width + coords.x
	return cells[index]
