class_name Selector


var brown_highlited_color = Vector2i(24,74)
var blue_highlited_color = Vector2i(38,78)

var selected_object = null
var selector_type = SelectorTypes.SELECTOR_TYPE.NONE  # "Settlement", "Unit", etc.

var main: Main

func _init(main: Main):
	self.main = main

func select_object(coords: Vector2i):
	if selector_type != SelectorTypes.SELECTOR_TYPE.NONE:
		selector_type = SelectorTypes.SELECTOR_TYPE.NONE
		selected_object = main.get_player()
	else:
		var tile = main.get_world_map().cells[coords.x + coords.y * main.get_world_map().width]  # Retrieve the tile ID from the coordinates
		if tile != null:
			if tile.building != null:
				selected_object = tile.building
				selector_type = SelectorTypes.SELECTOR_TYPE.BUILDING
			else:
				selected_object = tile
				selector_type = SelectorTypes.SELECTOR_TYPE.TILE	

	main.upd_ui()

func get_highlighted_tiles():
	var result = {}
	match selector_type:
		SelectorTypes.SELECTOR_TYPE.TILE:
			result[selected_object.coords] = brown_highlited_color
		SelectorTypes.SELECTOR_TYPE.BUILDING:
			result[selected_object.map_cell.coords] = brown_highlited_color
	
	return result
