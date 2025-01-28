class_name TileMapLayers extends Node2D

var main

var world_map
var terrain_layer
var settlement_layer


func _ready():
	main = get_node("/root/MainScene")
	terrain_layer = get_node("TerrainLayer")
	settlement_layer = get_node("SettlementLayer")
	#side_panel = get_node("/root/MainScene/UI/SidePanel")
	#rich_text_label = side_panel.get_node("RichTextLabel")
	#buttons_container = side_panel.get_node("ButtonsContainer")
	load_maps("data/map.json")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var local_mouse_position = to_local(event.position + main.map_camera.position)
		var tile_coords = terrain_layer.local_to_map(local_mouse_position)
		var tile = world_map.cells[tile_coords.x + tile_coords.y * world_map.width]  # Retrieve the tile ID from the coordinates
		if tile != null && main.curr_selected_obj != tile:
			main.selector.set_position(terrain_layer.map_to_local(tile_coords))
			main.curr_selected_obj = tile
			main.upd_ui()
	
	
func load_maps(file_name):
	var content = FileAccess.open(file_name, FileAccess.READ).get_as_text()
	var content_dict = JSON.parse_string(content)
	var height = content_dict["dimensions"][0]
	var width = content_dict["dimensions"][1]	
	
	world_map = preload("res://scripts/world_map.gd").new(width, height)
	
	
	for x in range(width):
		for y in range(height):
			var elevation = content_dict["elevation"][y*width + x]
			var moisture = content_dict["moisture"][y*width + x]
			var temperature = content_dict["temperature"][y*width + x]
			var biome = content_dict["biome"][y*width + x]
			var resources = {}
			for resource in content_dict["resources"]:
				resources[resource] = content_dict["resources"][resource][y*width + x]
			var cell = preload("res://scripts/map_cell.gd").new(elevation, moisture, temperature, biome, resources, Vector2i(x, y))
			world_map.set_cell(x,y,cell)
			terrain_layer.set_cell(Vector2i(x, y), 0, cell.get_terrain_graphics(), 0)

func update_tile(coords):
	settlement_layer.set_cell(coords, 0, world_map.get_cell(coords).get_settlement_graphics(), 0)
	
func _increate_elevation(tile):
	tile.elevation += 1
