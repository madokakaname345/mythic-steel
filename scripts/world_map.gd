class_name WorldMap

var main: Main
var width
var height
var cells = []

func _init(width, height, main):
	self.width = width
	self.height = height
	self.cells.resize(width * height)
	self.main = main

func set_cell(x, y, cell):
	var index = y * width + x
	cells[index] = cell

func get_cell(coords) -> MapCell:
	var index = coords.y * width + coords.x
	return cells[index]
