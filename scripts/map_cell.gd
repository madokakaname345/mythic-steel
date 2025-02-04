class_name MapCell

var elevation
var moisture
var temperature
var biome
var resources = {}
var units: Array[Unit] = []
var coords
var settlement
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
	0: INF, #ocean
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
	13: Vector2i(42, 85),
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

func get_settlement_graphics():
	# calc settlement graphics some way
	return Vector2i(0, 1)
	
func incr_elevation_ui():
	self.elevation += 1
	SignalBus.update_ui.emit()
	
func decr_elevation_ui():
	self.elevation -= 1
	SignalBus.update_ui.emit()
	
func create_settlement():
	self.settlement = Settlement.new(str("test settlemend %d %d" % [coords.x, coords.y]), self, main)
	SignalBus.update_tile.emit(coords)

func get_ui_data():

	var data = str("[b]Tile Information[/b]\n[b]Elevation:[/b] %f\n[b]Moisture:[/b] %f\n[b]Temperature:[/b] %f\n[b]Biome:[/b] %d\n" % [elevation, moisture, temperature, biome])
	if settlement != null:
		data = data + "[b]Settlement: [/b]" + settlement.name
	
	for res_name in resources.keys():
		var amount = resources[res_name]
		data = str(data, "- [color=green]%s[/color]: %d\n" % [res_name, amount])
	
	return data	
	
	
func get_ui_buttons():
	var buttons = []
	var button1 = Button.new()
	button1.text = str("add +1 elevation, curr elevation=", self.elevation)  # Set the button's text
	button1.pressed.connect(Callable(self, "incr_elevation_ui"))
	buttons.append(button1)
	
	var button2 = Button.new()
	button2.text = str("add -1 elevation, curr elevation=", self.elevation)  # Set the button's text
	button2.pressed.connect(Callable(self, "decr_elevation_ui"))
	buttons.append(button2)
	
	var button3 = Button.new()
	button3.text = str("Create settlement", self.elevation)  # Set the button's text
	button3.pressed.connect(Callable(self, "create_settlement"))
	buttons.append(button3)

	if settlement != null:
		var button4 = Button.new()
		button4.text = str("Build Iron Mine")  # Set the button's text
		button4.pressed.connect(Callable(self.settlement, "construct_building").bind("Mine"))
		buttons.append(button4)
		
	if settlement != null:
		var button5 = Button.new()
		button5.text = str("Hire Scout")  # Set the button's text
		button5.pressed.connect(Callable(self.settlement, "hire_unit").bind("Scout"))
		buttons.append(button5)
		
	
	return buttons
