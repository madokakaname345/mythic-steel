class_name MapCell

var elevation
var moisture
var temperature
var biome
var resources = {}
var units: Array[Unit] = []
var coords
var building: Building
var main: Main
var visibility = false

var atlas_mapping = {
	0: Vector2i(0, 46),
	1: Vector2i(5, 45),
	2: Vector2i(32, 35),
	3: Vector2i(38, 70),
	4: Vector2i(50, 54),
	5: Vector2i(51, 58),
	6: Vector2i(32, 42),
	7: Vector2i(9, 21),
	8: Vector2i(14, 24),
	9: Vector2i(3, 21),
	10: Vector2i(14, 75),
	11: Vector2i(47, 87),
	12: Vector2i(47, 86),
	13: Vector2i(42, 85),
}

var movement_cost_mapping = {
	0: 1000, #ocean
	1: 2, #beach
	2: 15, #scorched (mountains)
	3: 20, #bare (mountains)
	4: 5, #tundra
	5: 5, #snow
	6: 8, #desert
	7: 3, #shrubland
	8: 10, #taiga
	9: 2, #grassland
	10: 8, #temp forest
	11: 10, #temp rain forest
	12: 8, # seasonal forest,
	13: 100,
}

var undiscovered_tile_coords = Vector2i(50, 0)


func _init(elevation, moisture, temperature, biome, resources, coords, main):
	self.elevation = elevation
	self.moisture = moisture
	self.temperature = temperature
	self.biome = biome
	self.resources = resources
	self.coords = coords
	self.main = main
	self.visibility = false  # Default to hidden

func get_movement_cost() -> int:
	return movement_cost_mapping[int(biome)]


func get_terrain_graphics(global_visibility: bool):
	if global_visibility || visibility:
		return atlas_mapping[int(biome)]
	else:
		return undiscovered_tile_coords

func get_building_graphics():
	# calc building graphics some way
	return Vector2i(0, 1)

func get_building() -> Building:
	return building

func incr_elevation_ui():
	self.elevation += 1
	SignalBus.update_ui.emit()
	
func decr_elevation_ui():
	self.elevation -= 1
	SignalBus.update_ui.emit()
	
func create_building(building_sample: Building):
	#self.building = Settlement.new(str("test settlemend %d %d" % [coords.x, coords.y]), self, main)
	# var new_building
	var new_building = Building.new(self)
	new_building.load(building_sample.file_path)

	if not new_building.can_be_built():
		print(new_building.type, "cannot be built at ", self.coords)
		return

	if not get_player().has_resources(new_building.cost):
		print("Not enough resources to build ", new_building.type)
		return

	get_player().spend_resources(new_building.cost)
	self.building = new_building
	get_player().buildings.append(new_building)
	print(new_building.type, "built successfully!")
	SignalBus.update_tile.emit(self.coords)
	return new_building

func get_ui_data():

	var data = str("[b]Tile Information[/b]\n[b]Elevation:[/b] %f\n[b]Moisture:[/b] %f\n[b]Temperature:[/b] %f\n[b]Biome:[/b] %d\n" % [elevation, moisture, temperature, biome])
	
	return data	

func get_resources():
	return resources	

func get_ui_buttons():
	var buttons = []
	var button1 = Button.new()
	button1.text = str("add +1 elevation, curr elevation=", self.elevation)
	button1.pressed.connect(Callable(self, "incr_elevation_ui"))
	buttons.append(button1)
	
	var button2 = Button.new()
	button2.text = str("add -1 elevation, curr elevation=", self.elevation)
	button2.pressed.connect(Callable(self, "decr_elevation_ui"))
	buttons.append(button2)

	var button4 = Button.new()
	button4.text = str("Create pop (debug)", self.elevation)
	button4.pressed.connect(Callable(self, "debug_create_pop"))
	buttons.append(button4)

	if building != null:
		buttons += building.get_ui_buttons()
	
	return buttons

func debug_create_pop():
	var new_pop = Pop.new()

	var res_loc = get_player().get_free_res_building()
	if res_loc == null:
		print("no free res slots, homeless pop")
	else:
		res_loc.residents.append(new_pop)
		new_pop.residence = res_loc
	get_player().pops.append(new_pop)
	
func dir_action(coords: Vector2i):
	if self.building != null && self.building.cells.has(main.tile_map_layers.world_map.get_cell(coords)):
		self.building.settlement_selected_tile = main.tile_map_layers.world_map.get_cell(coords)

func find_path(target: Vector2i) -> Array:
	return main.tile_map_layers.world_map.find_path(coords, target)

func get_biome():
	return biome

func get_main() -> Main:
	return main

func get_player() -> Player:
	return main.get_player()
