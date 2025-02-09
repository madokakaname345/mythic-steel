class_name Scout extends Unit # Pure data, no scene

func _init(cell: MapCell):
	super._init(cell)
	self.name = "Scout123456"
	self.unit_type = "Scout"
	self.cost = {"wood": 50, "stone": 30}
	self.max_movement_points = 20
	self.curr_movement_points = self.max_movement_points
	self.vision_radius = 4

func get_graphics():
	return Vector2i(0,0)
