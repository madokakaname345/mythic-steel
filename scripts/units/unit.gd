class_name Unit
extends RefCounted  # Pure data, no scene

var cell: MapCell
var movement_points: int
var vision_radius: int

func _init(unit_type: String, cell: MapCell, owner_id: int):
    self.cell = cell
    self.movement_points = 10
    self.vision_radius = 1
