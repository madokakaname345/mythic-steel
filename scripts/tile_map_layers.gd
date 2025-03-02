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
		SignalBus.process_select.emit(tile_coords)

	#TODO: refactor as for left mouse button
	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
		var local_mouse_position = to_local(event.position + main.map_camera.position)
		var tile_coords = terrain_layer.local_to_map(local_mouse_position)
		var tile = world_map.cells[tile_coords.x + tile_coords.y * world_map.width]  # Retrieve the tile ID from the coordinates
		main.selector.selected_object.dir_action(tile.coords)

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

func update_highlighted_tiles(selector: Selector):
	clear_highlighted_tiles()
	var tiles_to_highlight = selector.get_highlighted_tiles()
	for tile in tiles_to_highlight:
		highlighted_layer.set_cell(tile, 0, tiles_to_highlight[tile], 0)
	
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
