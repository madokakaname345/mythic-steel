class_name WorldMap

var main: Main
var width: int
var height: int
var cells = []

func _init(width, height, main):
	self.width = width
	self.height = height
	self.cells.resize(width * height)
	self.main = main

func set_cell(x, y, cell):
	var index = y * width + x
	cells[index] = cell

func get_cell(coords: Vector2i) -> MapCell:
	if coords.x >= width || coords.x < 0:
		coords.x = ((coords.x % width) + width) % width
	if coords.y >= height || coords.y < 0:
		coords.y = ((coords.y % height) + height) % height
	var index = coords.y * width + coords.x
	return cells[index]
