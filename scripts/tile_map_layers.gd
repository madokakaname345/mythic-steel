class_name TileMapLayers extends Node2D

var main: Main

var world_map: WorldMap
var terrain_layer: TileMapLayer
var settlement_layer: TileMapLayer
var highlighted_layer: TileMapLayer
var unit_layer: TileMapLayer

var blink_timer = 0
var blink_on = true
var blink_interval = 0.5

var is_globally_visible: bool 


func _ready():
	main = get_node("/root/MainScene")
	terrain_layer = get_node("TerrainLayer")
	settlement_layer = get_node("SettlementLayer")
	highlighted_layer = get_node("HighlightedLayer")
	unit_layer = get_node("UnitLayer")
	#side_panel = get_node("/root/MainScene/UI/SidePanel")
	#rich_text_label = side_panel.get_node("RichTextLabel")
	#buttons_container = side_panel.get_node("ButtonsContainer")
	is_globally_visible = true
	load_maps("data/map.json")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var local_mouse_position = to_local(event.position + main.map_camera.position)
		var tile_coords = terrain_layer.local_to_map(local_mouse_position)
		var tile = world_map.cells[tile_coords.x + tile_coords.y * world_map.width]  # Retrieve the tile ID from the coordinates
		if tile != null:
			# select priority: settlement > unit > tile
			if tile.settlement != null:
				#if there is a settlement on the tile - select it
				if tile.settlement.units.size()>0:
					if main.curr_selected_obj != tile.settlement.units[0]:
						main.curr_selected_obj = tile.settlement.units[0]
						var tiles_to_highlight = world_map.get_tiles_in_range(tile.settlement.units[0].cell.coords, tile.settlement.units[0].curr_movement_points)
						update_highlighted_tiles(tiles_to_highlight)
			elif tile.units.size() > 0:
				# if there are units on the tile - select the first one
				if main.curr_selected_obj != tile.units[0]:
					main.curr_selected_obj = tile.units[0]
					var tiles_to_highlight = world_map.get_tiles_in_range(tile.units[0].cell.coords, tile.units[0].movement)
					update_highlighted_tiles(tiles_to_highlight)
			elif main.curr_selected_obj != tile:
				main.curr_selected_obj = tile
				update_highlighted_tiles([tile_coords])
			
			main.upd_ui()

	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
		var local_mouse_position = to_local(event.position + main.map_camera.position)
		var tile_coords = terrain_layer.local_to_map(local_mouse_position)
		var tile = world_map.cells[tile_coords.x + tile_coords.y * world_map.width]  # Retrieve the tile ID from the coordinates
		main.curr_selected_obj.dir_action(tile.coords)

func _process(delta):
	blink_timer += delta
	if blink_timer >= blink_interval:
		blink_timer = 0
		highlighted_layer.set_visible(blink_on)
		blink_on = !blink_on	
	
func load_maps(file_name):
	var content = FileAccess.open(file_name, FileAccess.READ).get_as_text()
	var content_dict = JSON.parse_string(content)
	var height = content_dict["dimensions"][0]
	var width = content_dict["dimensions"][1]	
	
	world_map = preload("res://scripts/world_map.gd").new(width, height, main)
	
	
	for x in range(width):
		for y in range(height):
			var elevation = content_dict["elevation"][y*width + x]
			var moisture = content_dict["moisture"][y*width + x]
			var temperature = content_dict["temperature"][y*width + x]
			var biome = content_dict["biome"][y*width + x]
			var resources = {}
			for resource in content_dict["resources"]:
				resources[resource] = content_dict["resources"][resource][y*width + x]
			var cell = preload("res://scripts/map_cell.gd").new(elevation, moisture, temperature, biome, resources, Vector2i(x, y), main)
			world_map.set_cell(x,y,cell)
			terrain_layer.set_cell(Vector2i(x, y), 0, cell.get_terrain_graphics(is_globally_visible), 0)

func update_tile(coords):
	settlement_layer.erase_cell(coords)
	unit_layer.erase_cell(coords)
	terrain_layer.set_cell(coords, 0, world_map.get_cell(coords).get_terrain_graphics(is_globally_visible), 0)
	if world_map.get_cell(coords).settlement != null:
		settlement_layer.set_cell(coords, 0, world_map.get_cell(coords).get_settlement_graphics(), 0)
		return
	if world_map.get_cell(coords).units.size() > 0:
		unit_layer.set_cell(coords, 0, world_map.get_cell(coords).units[0].get_graphics(), 0)
		return
		

func update_terrain():
	for x in range(world_map.width):
		for y in range(world_map.height):
			terrain_layer.set_cell(Vector2i(x, y), 0, world_map.get_cell(Vector2i(x, y)).get_terrain_graphics(is_globally_visible), 0)

func clear_highlighted_tiles():
	highlighted_layer.clear()

func update_highlighted_tiles(tileCoords: Array):
	clear_highlighted_tiles()
	for coord in tileCoords:
		highlighted_layer.set_cell(coord, 0, Vector2i(24,74), 0)
	
func _increate_elevation(tile):
	tile.elevation += 1

func get_resources_in_radius(r: int, coords: Vector2i):
	assert(r >=0, "r should be not negative")
	var resources = {}
	if r == 0:
		return world_map.get_cell(coords).resources
	for i in range(-r, r):
		for j in range(-r, r):
			if (world_map.get_cell(coords + Vector2i(i,j)).resources.size()) > 0:
				for res_name in world_map.get_cell(coords + Vector2i(i,j)).resources.keys():
					if resources.has(res_name):
						resources[res_name] += world_map.get_cell(coords + Vector2i(i,j)).resources[res_name]
					else:
						resources[res_name] = world_map.get_cell(coords + Vector2i(i,j)).resources[res_name]
	return resources
	

func toggle_global_visibility(upd_map: bool):
	is_globally_visible = !is_globally_visible
	if upd_map:
		update_terrain()
