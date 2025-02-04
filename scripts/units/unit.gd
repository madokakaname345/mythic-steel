class_name Unit
extends RefCounted  # Pure data, no scene

var name: String
var owner_id: int
var unit_type: String
var cost: Dictionary
var cell: MapCell
var max_movement_points: int
var curr_movement_points: int
var vision_radius: int

func _init(cell: MapCell):
	self.cell = cell
	self.unit_type = unit_type
	self.owner_id = 1

func upd_visibility():
	pass

func upd_highlighted():
	print("highlighted updated")
	pass
