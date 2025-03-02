class_name Unit
extends RefCounted  # Pure data, no scene

var name: String
var owner_id: int
var unit_type: String
var cost: Dictionary
var cell: MapCell
var max_movement_points: int
var curr_movement_points: int
var visibility_radius: int

func _init(cell: MapCell):
	self.cell = cell
	self.unit_type = unit_type
	self.owner_id = 1
	SignalBus.unit_created.emit(self)

func upd_visibility():
	# visibility radius 2
	for i in range (-visibility_radius,visibility_radius + 1):
		for j in range(-visibility_radius,visibility_radius + 1):
			cell.main.tile_map_layers.world_map.get_cell(cell.coords + Vector2i(i,j)).visibility = true
			SignalBus.update_tile.emit(cell.coords + Vector2i(i,j))
	
func get_graphics():
	pass

func upd_highlighted():
	print("highlighted updated")
	pass
	
func end_turn():
	curr_movement_points = max_movement_points

func dir_action(coords: Vector2i):
	var path = cell.find_path(coords)
	print(path)
	for step in path:
		print(step)
		move_unit(step)
	#move_unit()

func move_unit(coords: Vector2i):
	var new_cell = cell.main.tile_map_layers.world_map.get_cell(coords)
	if new_cell != null:
		var old_coords = cell.coords
		if curr_movement_points < new_cell.get_movement_cost():
			print("Not enough movement points")
			return
		cell.units.erase(self)
		if cell.settlement != null:
			cell.settlement.units.erase(self)
		new_cell.units.append(self)
		cell = new_cell
		curr_movement_points -= new_cell.get_movement_cost()
		SignalBus.update_tile.emit(coords)
		SignalBus.update_tile.emit(old_coords)
		SignalBus.update_ui.emit()
	upd_visibility()
	
func get_ui_data():
	return str("[b]This is a dumb unit of a type [/b]\n[b]Type:[/b] %s\n" % self.unit_type)
	
func get_ui_buttons():
	return []
