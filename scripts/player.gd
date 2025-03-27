class_name Player

var buildings: Array[Building] = []
var pops: Array[Pop] = []

var main: Main

var all_buildings: Array[Building]

func _init(main):
	self.main = main
	all_buildings = []
	var dir := DirAccess.open("res://data/buildings")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	var fake_map_cell = MapCell.new(0, 0, 0, 0, null, null, main)
	for file: String in dir.get_files():
		var building = Building.new(fake_map_cell)
		building.load(str("%s/%s" % [dir.get_current_dir(), file]))
		all_buildings.append(building)
	dir.list_dir_end()

func get_free_res_building():
	# get through every building and look for free residende slots
	for building in buildings:
		if building.max_residents > building.residents.size():
			return building
	# if no free res slots - return null
	return null
	
func end_turn():
	# sort buildings. Warehouses last
	buildings.sort_custom(func(a, b): 
		if a.is_warehouse() and !b.is_warehouse():
			return false
		elif b.is_warehouse() and !a.is_warehouse():
			return true
		else:
			return false
		)
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
	var all_res = get_all_resources()
	for resource in cost.keys():
		if all_res.get(resource, 0) < cost[resource]:
			return false
	return true

func spend_resources(cost: Dictionary):
	for resource in cost.keys():
		var remaining = cost[resource]
		var was_built = false
		for building in buildings:
			if building.stock.has(resource):
				var amount = min(remaining, building.stock[resource])
				remaining -= amount
				building.stock[resource] -= amount
				if remaining == 0:
					was_built = true
					break
		if !was_built:
			printerr(str("Not enough resources to spend! Please check (debug) %s" % [resource]))

func get_all_resources() -> Dictionary:
	var result = {}
	for building in buildings:
		for resource in building.stock:
			if !result.has(resource):
				result[resource] = 0
			result[resource] += building.stock[resource]
	return result
