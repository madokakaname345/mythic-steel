class_name Settlement


var name: String
#var food
var buildings: Array[Building] = []
var units: Array[Unit] = []
var resources = {}
var cells: Array[MapCell]
var main: Main

var atlas_mapping = Vector2i(0, 3)

func _init(name: String, cell: MapCell, main: Main):
	self.name = name
	self.resources = {"wood": 100, "stone": 60, "iron": 5, "bmats": 1000}
	self.main = main
	#get 3x3 neighbors
	self.cells = [cell]
	cell.settlement = self
	var neighbor_coords = main.tile_map_layers.world_map.get_neighbors(cell.coords)
	for coords in neighbor_coords:
		var temp_cell = main.tile_map_layers.world_map.get_cell(coords)
		if temp_cell.settlement != null:
			print("cell already assigned to a settlement")
			continue
		self.cells.append(temp_cell)
		temp_cell.settlement = self
	upd_visibility()
	SignalBus.settlement_created.emit(self)

func end_turn():
	for building in buildings:
		building.on_turn_end()
	# spare resources on pops
	# get all pops
	var pops = get_all_pops()
	# for every pop - spare resources
	#optinal: sort pops by priority
	for pop in pops:
		spare_resources_on_pop(pop)
	# if pop is over the surv res limit - create new pop of the same culture + religion
		if pop.basic_needs_progress >= pop.basic_needs_progress_max:
			# if there is no free space in the city - don't create new pop, keep needs progress
			var work_loc = get_free_work_building()
			var res_loc = get_free_res_building()

			if res_loc == null:
				var cell = get_cell_with_free_building_slot()
				if cell == null:
					print("no free building slots and res locations, pop growth failed")
					return
				else:
					res_loc = construct_building("DebugSlums", cell)

			var new_pop = Pop.new()
			new_pop.residence = res_loc
			res_loc.residents.append(new_pop)

			if work_loc != null:
				new_pop.assignment = work_loc
				work_loc.workers.append(new_pop)
			else:
				print("unemployed pop created")
			pop.basic_needs_progress = 5
			print("pop growth")


		elif pop.basic_needs_progress <= 0:
			# if pop is under the surv res limit - kill the pop
			pop.assignment.workers.erase(pop)
			pop.residence.residents.erase(pop)
			SignalBus.pop_deleted.emit(pop)
			print("pop died")
			# pop.queue_free()
	print("settlement turn ended")

func get_all_pops():
	var pops = []
	for building in buildings:
		pops += building.residents
	return pops

func get_tiles():
	return cells

func spare_resources_on_pop(pop: Pop):
	# get pop's basic needs
	var basic_needs_progress_change = 1
	var turn_needs = pop.basic_needs.duplicate(true)
	for k in turn_needs:
		if resources.has(k):
			var existing_res = min(turn_needs[k], resources[k])
			turn_needs[k] -= existing_res
			resources[k] -= existing_res
		else:
			resources[k] = 0
		if turn_needs[k] > 0:
			basic_needs_progress_change -= 2
	
	pop.basic_needs_progress += basic_needs_progress_change
	

func get_free_res_building():
	# get through every building and look for free residende slots
	for building in buildings:
		if building.max_residents > building.residents.size():
			return building
	# if no free res slots - return null
	return null

func get_free_work_building():
	# get through every building and look for free worker slots
	for building in buildings:
		if building.max_workers > building.workers.size():
			return building
	# if no free slots - return null
	return null

func hire_unit(unit_type: String, cell: MapCell = null):
	
	if cell == null:
		print("No cell provided. Please select cell to hire unit on")
		return
	var new_unit

	match unit_type:
		"Scout":
			new_unit = Scout.new(cell)
		_: 
			print("Invalid unit type")
			return

	if not has_resources(new_unit.cost):
		print("Not enough resources to build", unit_type)
		return

	spend_resources(new_unit.cost)
	cell.units.append(new_unit)
	print(unit_type, "hired successfully!")
	
func get_cell_with_free_building_slot():
	for cell in cells:
		if cell.buidlings.size() >= cell.max_buidlings:
			print("Cannot build more buildings on this cell")
		else:
			return cell
	return

func construct_building(building_type: String, cell: MapCell = null): 
	var new_building

	if cell == null:
		print("No cell provided. Please select cell to build on")
		return

	if cell.buidlings.size() >= cell.max_buidlings:
		print("Cannot build more buildings on this cell")
		return

	match building_type:
		"Mine":
			new_building = IronMine.new(self, cell)
		"DebugFarm":
			new_building = DebugFarm.new(self, cell)
		"DebugResidentialDistrict":
			new_building = DebugResidentialDistrict.new(self, cell)
		"DebugSlums":
			new_building = DebugSlums.new(self, cell)
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
	cell.buidlings.append(new_building)
	buildings.append(new_building)
	print(building_type, "built successfully!")
	return new_building

func debug_create_pop():
	var res_loc = get_free_res_building()
	if res_loc == null:
		print("no free res slots, debug pop creation failed")
		return
	
	var work_loc = get_free_work_building()
	if work_loc == null:
		print("no free work slots, debug pop creation failed")
		return

	var new_pop = Pop.new()
	res_loc.residents.append(new_pop)
	new_pop.residence = res_loc
	work_loc.workers.append(new_pop)
	new_pop.assignment = work_loc

func has_resources(cost: Dictionary) -> bool:
	for resource in cost.keys():
		if resources.get(resource, 0) < cost[resource]:
			return false
	return true

func spend_resources(cost: Dictionary):
	for resource in cost.keys():
		resources[resource] -= cost[resource]

func get_nearby_resources():
	return main.get_resources_in_radius(2, cells[0].coords)

func upd_visibility():
	# visibility radius 2
	for i in range (-2,2 + 1):
		for j in range(-2,2 + 1):
			main.tile_map_layers.world_map.get_cell(cells[0].coords + Vector2i(i,j)).visibility = true
			SignalBus.update_tile.emit(cells[0].coords)

func get_ui_buttons():
	var buttons = []
	var selected_cell
	if main.selector.selector_type == SelectorTypes.SELECTOR_TYPE.SETTLEMENT_TILE:
		selected_cell = main.selector.selected_object
	# get settlement buttons
	var button4 = Button.new()
	button4.text = str("Build Iron Mine")  # Set the button's text
	button4.pressed.connect(Callable(self, "construct_building").bind("Mine", selected_cell))
	buttons.append(button4)

	var button5 = Button.new()
	button5.text = str("Build Debug Farm")  # Set the button's text
	button5.pressed.connect(Callable(self, "construct_building").bind("DebugFarm", selected_cell))
	buttons.append(button5)

	var button6 = Button.new()
	button6.text = str("Build Debug ResidentialDistrict")  # Set the button's text
	button6.pressed.connect(Callable(self, "construct_building").bind("DebugResidentialDistrict", selected_cell))
	buttons.append(button6)

	var button7 = Button.new()
	button7.text = str("Hire Scout")  # Set the button's text
	button7.pressed.connect(Callable(self, "hire_unit").bind("Scout", selected_cell))
	buttons.append(button7)

	var button8 = Button.new()
	button8.text = str("Debug create pop in first free building")  # Set the button's text
	button8.pressed.connect(Callable(self, "debug_create_pop"))
	buttons.append(button8)


	return buttons

func get_ui_data():
	var data = str("[b]Settlement Information[/b]\n[b]Name:[/b] %s" % name)
	return data

func get_name():
	return name
