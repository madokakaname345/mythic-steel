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
	
