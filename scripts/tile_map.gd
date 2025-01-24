extends TileMapLayer

var world_map
var curr_cell

func _ready():
	load_maps("data/map.json")
	
	
func _process(delta):
	pass
	
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
			var cell = preload("res://scripts/map_cell.gd").new(elevation, moisture, temperature, biome, resources)
			world_map.set_cell(x,y,cell)
			set_cell(Vector2i(x, y), 0, cell.get_atlas_coord(), 0)

	curr_cell = world_map.get_cell(0, 0)
	print("Loaded map with dimensions: ", width, "x", height)
	print("Current cell data: ", curr_cell)
	
