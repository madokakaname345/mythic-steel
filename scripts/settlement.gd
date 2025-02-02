class_name Settlement


var name
var population
var food
var buildings: Array[Building] = []
var resources = {}
var cell: MapCell
var main: Main

var atlas_mapping = Vector2i(0, 3)

func _init(name: String, cell: MapCell, main: Main):
	self.name = name
	self.population = 1
	self.food = 10
	self.resources = {"wood": 100, "stone": 60, "iron": 5}
	self.cell = cell
	self.main = main
	upd_visibility()
	SignalBus.settlement_created.emit(self)

func end_turn():
	#calc food
	food += 1
	if food > 10:
		food = 5
		population += 1
		print("pop growth")
	for building in buildings:
		building.on_turn_end()
	print("settlement turn ended")
	
func construct_building(building_type: String):
	var new_building

	match building_type:
		"Mine":
			new_building = IronMine.new(self)
		_:
			print("Invalid building type")
			return

	if not new_building.can_be_built():
		print(building_type, "cannot be built at", cell.coords)
		return

	if not has_resources(new_building.cost):
		print("Not enough resources to build", building_type)
		return

	spend_resources(new_building.cost)
	buildings.append(new_building)
	print(building_type, "built successfully!")

func has_resources(cost: Dictionary) -> bool:
	for resource in cost.keys():
		if resources.get(resource, 0) < cost[resource]:
			return false
	return true

func spend_resources(cost: Dictionary):
	for resource in cost.keys():
		resources[resource] -= cost[resource]

func get_nearby_resources():
	return main.get_resources_in_radius(2, cell.coords)

func upd_visibility():
	# visibility radius 2
	for i in range (-2,2 + 1):
		for j in range(-2,2 + 1):
			main.tile_map_layers.world_map.get_cell(cell.coords + Vector2i(i,j)).visibility = true
			SignalBus.update_tile.emit(cell.coords)
