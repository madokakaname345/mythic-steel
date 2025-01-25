class_name MapCell

var elevation
var moisture
var temperature
var biome
var resources = {}

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


func _init(elevation, moisture, temperature, biome, resources):
	self.elevation = elevation
	self.moisture = moisture
	self.temperature = temperature
	self.biome = biome
	self.resources = resources


func get_atlas_coord():
	return atlas_mapping[int(biome)]
	
func incr_elevation_ui():
	self.elevation += 1
	SignalBus.update_ui.emit()
	
func decr_elevation_ui():
	self.elevation -= 1
	SignalBus.update_ui.emit()

func get_ui_data():

	var data = str("[b]Tile Information[/b]\n[b]Elevation:[/b] %f\n[b]Moisture:[/b] %f\n[b]Temperature:[/b] %f\n[b]Biome:[/b] %d\n" % [elevation, moisture, temperature, biome])
	
	for res_name in resources.keys():
		var amount = resources[res_name]
		data = str(data, "- [color=green]%s[/color]: %d\n" % [res_name, amount])
	
	return data	
	
	
func get_ui_buttons():
	var button1 = Button.new()
	button1.text = str("add +1 elevation, curr elevation=", self.elevation)  # Set the button's text
	button1.pressed.connect(Callable(self, "incr_elevation_ui"))
	
	var button2 = Button.new()
	button2.text = str("add -1 elevation, curr elevation=", self.elevation)  # Set the button's text
	button2.pressed.connect(Callable(self, "decr_elevation_ui"))
	
	return [button1, button2]
