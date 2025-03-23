class_name Player

var resources = {}
var buildings: Array[Building] = []
var pops: Array[Pop] = []

var all_buildings: Array[Building]

func _init():
	all_buildings = []
	var dir := DirAccess.open("res://data/buildings")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	for file: String in dir.get_files():
		var building = Building.new(null)
		building.load(str("%s/%s" % [dir.get_current_dir(), file]))
		all_buildings.append(building)
	dir.list_dir_end()
	
	self.resources = {"wood": 100, "stone": 60, "iron": 5, "bmats": 1000}

func get_free_res_building():
	# get through every building and look for free residende slots
	for building in buildings:
		if building.max_residents > building.residents.size():
			return building
	# if no free res slots - return null
	return null
	
func end_turn():
	for building in buildings:
		building.on_turn_end()

func get_available_pops_for_production_option(prod_option: GenericProductionOption) -> Array:
	var available_pops = []
	for pop in pops:
		if pop.can_be_assigned_to(prod_option):
			available_pops.append(pop)
	return available_pops
	
func get_available_buildings() -> Array[Building]:
	return all_buildings

func has_resources(cost: Dictionary) -> bool:
	for resource in cost.keys():
		if resources.get(resource, 0) < cost[resource]:
			return false
	return true

func spend_resources(cost: Dictionary):
	for resource in cost.keys():
		resources[resource] -= cost[resource]
