class_name Selector

# AVAILABLE TYPE TRANSITIONS:
# NONE -> TILE
# TILE -> UNIT
# NONE -> SETTLEMENT
# SETTLEMENT -> SETTLEMENT_TILE
# SETTLEMENT_TILE -> SETTLEMENT_TILE
# SETTLEMENT -> UNIT
# SETTLEMENT_TILE -> UNIT
# ANY -> NONE


var brown_highlited_color = Vector2i(24,74)
var blue_highlited_color = Vector2i(38,78)

var selected_object = null
var selector_type = SelectorTypes.SELECTOR_TYPE.NONE  # "Settlement", "Unit", etc.

var main: Main

func _init(main: Main):
	self.main = main

func select_object(coords: Vector2i):
	var tile = main.get_world_map().cells[coords.x + coords.y * main.get_world_map().width]  # Retrieve the tile ID from the coordinates
	if tile != null:
		if selector_type == SelectorTypes.SELECTOR_TYPE.NONE:
			# select tile if no settlements or units are present
			# select settlement if tile has a settlement
			# select unit if tile has a unit
			if tile.settlement != null:
				selected_object = tile.settlement
				selector_type = SelectorTypes.SELECTOR_TYPE.SETTLEMENT
			elif tile.units.size() > 0:
				selected_object = tile.units[0]
				selector_type = SelectorTypes.SELECTOR_TYPE.UNIT
			else:
				selected_object = tile
				selector_type = SelectorTypes.SELECTOR_TYPE.TILE
		
		elif selector_type == SelectorTypes.SELECTOR_TYPE.SETTLEMENT:
			# if current selection is a settlement
			# if the tile is a settltment tile of this settlement - settlement_tile selection
			if tile.settlement == selected_object:
				selected_object = tile
				selector_type = SelectorTypes.SELECTOR_TYPE.SETTLEMENT_TILE
			else:
				selected_object = null
				selector_type = SelectorTypes.SELECTOR_TYPE.NONE
				select_object(coords)

		elif selector_type == SelectorTypes.SELECTOR_TYPE.SETTLEMENT_TILE:
			# if current selection is a settlement tile
			# if the tile has a unit - unit selection
			if tile.units.size() > 0:
				selected_object = tile.units[0]
				selector_type = SelectorTypes.SELECTOR_TYPE.UNIT
			elif tile.settlement == selected_object.settlement:
				selected_object = tile
				selector_type = SelectorTypes.SELECTOR_TYPE.SETTLEMENT_TILE
			else:
				selected_object = null
				selector_type = SelectorTypes.SELECTOR_TYPE.NONE
				select_object(coords)
		
		elif selector_type == SelectorTypes.SELECTOR_TYPE.TILE:
			selected_object = null
			selector_type = SelectorTypes.SELECTOR_TYPE.NONE
			select_object(coords)

		elif selector_type == SelectorTypes.SELECTOR_TYPE.UNIT:
			# if current selection is a unit
			# todo: when multiple units - select the next one
			# for now - do nothing
			selected_object = null
			selector_type = SelectorTypes.SELECTOR_TYPE.NONE
			select_object(coords)
			
		elif selector_type == SelectorTypes.SELECTOR_TYPE.BUILDING:
			# if current selection is a building
			# do nothing
			selected_object = null
			selector_type = SelectorTypes.SELECTOR_TYPE.NONE
			select_object(coords)
		
		else:
			print("Selector: unknown selector type") # should never happen
		

		main.upd_ui()

func get_highlighted_tiles():
	var result = {}
	match selector_type:
		SelectorTypes.SELECTOR_TYPE.TILE:
			result[selected_object.coords] = brown_highlited_color
		SelectorTypes.SELECTOR_TYPE.SETTLEMENT:
			# select all settlement tiles
			for cell in selected_object.cells:
				result[cell.coords] = brown_highlited_color
		SelectorTypes.SELECTOR_TYPE.UNIT:
			for tile in main.get_world_map().get_tiles_in_range(selected_object.cell.coords, selected_object.curr_movement_points):
				result[tile] = blue_highlited_color
			result[selected_object.cell.coords] = brown_highlited_color
		SelectorTypes.SELECTOR_TYPE.SETTLEMENT_TILE:
			for cell in selected_object.settlement.cells:
				result[cell.coords] = blue_highlited_color
			result[selected_object.coords] = brown_highlited_color
		SelectorTypes.SELECTOR_TYPE.BUILDING:
			for cell in selected_object.settlement.cells:
				result[cell.coords] = blue_highlited_color
			result[selected_object.map_cell.coords] = brown_highlited_color
	
	return result
