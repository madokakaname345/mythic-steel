class_name Unit
extends RefCounted  # Pure data, no scene

var cell: MapCell
var max_movement_points: int
var curr_movement_points: int
var vision_radius: int

func _init(unit_type: String, cell: MapCell, owner_id: int):
	self.cell = cell
	self.max_movement_points = 20
	self.curr_movement_points = self.max_movement_points
	self.vision_radius = 1
