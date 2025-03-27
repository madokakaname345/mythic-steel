class_name Building

var name: String
var descripion: String
var type: String

var file_path: String

var cost: Dictionary
var build_progress: int

var stock_capacity: int
var stock: Dictionary

var production_options: Dictionary

var main: Main

# pops are assigned to these slots

# resident slots
var residents: Array
var max_residents: int

#worker slots
var workers: Array
var max_workers: int
var map_cell: MapCell

func _init(map_cell: MapCell):
	self.map_cell = map_cell
	self.main = map_cell.get_main()
	self.stock = {}
	
# Override in child classes
func can_be_built() -> bool:
	return true  # Default: Always valid

func on_turn_end():
	# iterate over production options
	var player = get_player()
	var resources_to_add = {}
	for production_option in production_options:
		if production_option is BaseProductionOption:
			var pop = production_option.assigned_pop
			if pop == null:
				continue
			var productivity = clamp(pop.get_productivity()[Consts.LOWER_CLASS][production_option.input_resource_type], 0, production_option.max_production_input_amount)
			for resource in production_option.production_per_unit:
				if !resources_to_add.has(resource):
					resources_to_add[resource] = 0
				resources_to_add[resource] += productivity * production_option.production_per_unit[resource]

	for result_res in resources_to_add:
		if !stock.has(result_res):
			stock[result_res] = 0
		stock[result_res] += resources_to_add[result_res]

	# this should be a production type in the warehouse
	for production_option in production_options:
		if production_option is HaulingProductionOption && production_option.type == ResourceTypes.HAULING_TYPE.COLLECT_ALL_TO:
			# haul resources to the current building
			# 1. check worker
			var pop = production_option.assigned_pop
			if pop == null:
				continue
			var remaining_energy = pop.get_remaining_energy()
			# 2 iterate through the buildings
			for building in get_player().buildings:
				# 3. check if the building has the resource
				if building == self:
					continue
				if building.stock.size() > 0:
					# 4. haul as much as possible
					for resource in building.stock:
						# get max amount to haul
						# distance * weight 
						# 3. check if the building has the resource
						# 4. haul as much as possible
						
						
						# var distance = find_path(building.map_cell.coords).size()
						var distance = 10
						var coeff = 10
						var max_haul = coeff * remaining_energy / (main.get_res_info(resource)["weight"] * distance)
						var amount = min(max_haul, building.stock[resource])

						if amount > 0:
							if !stock.has(resource):
								stock[resource] = 0
							stock[resource] += amount
							building.stock[resource] -= amount
							remaining_energy -= pop.calc_required_energy_to_haul(resource, distance, amount)


func get_workers() -> Array:
	return workers

func get_max_workers() -> int:
	return max_workers

func get_residents() -> Array:
	return residents

func get_max_residents() -> int:
	return max_residents
	
func get_name():
	return name

func get_ui_data() -> String:
	return str("Name: %s" % name)

func get_type() -> String:
	return type

func get_production_options() -> Dictionary:
	return production_options

func get_main() -> Main:
	return map_cell.get_main()

func get_player() -> Player:
	return map_cell.get_main().get_player()

func load(file_name: String):
	var content = FileAccess.open(file_name, FileAccess.READ).get_as_text()
	var content_dict = JSON.parse_string(content)
	self.file_path = file_name
	self.name = content_dict["name"]
	self.descripion = content_dict["description"]
	self.type = content_dict["type"]
	self.cost = content_dict["cost"]
	if content_dict.has("stock_capacity"):
		self.stock_capacity = content_dict["stock_capacity"]
	else:
		self.stock_capacity = 0
	
	self.max_residents = content_dict["max_residents"]

	for production_option in content_dict["production_options"]:
		var new_production_option
		match production_option["production_type"]:
			Consts.BASE_PRODUCTION:
				new_production_option = BaseProductionOption.new()
				new_production_option.production_per_unit = production_option["production_per_unit"]
				new_production_option.max_production_input_amount = production_option["max_production_input_amount"]
				new_production_option.input_resource_type = ResourceTypes.PRODUCTION_TYPE.get(production_option["input_resource_type"])
				new_production_option.energy_cost = production_option["energy_cost"]
			Consts.HAUL:
				new_production_option = HaulingProductionOption.new()
				new_production_option.type = ResourceTypes.HAULING_TYPE.get(production_option["hauling_type"])
		new_production_option.name = production_option["name"]
		new_production_option.description = production_option["description"]
		self.production_options[new_production_option] = null

	if self.type == "debug_warehouse":
		self.stock = {
			ResourceTypes.BUILDING_MATERIALS: 1000, 
			ResourceTypes.FOOD: 1000
			}

func get_ui_buttons():
	return []
	
func is_warehouse():
	return type == "debug_warehouse"
