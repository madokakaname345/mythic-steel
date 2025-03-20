class_name Building

var name: String
var type: String

var cost: Dictionary
var build_progress: int

var production_options: Dictionary


# pops are assigned to these slots

# resident slots
var residents: Array
var max_residents: int

#worker slots
var workers: Array
var max_workers: int

var settlement: Settlement
var map_cell: MapCell

func _init(settlement: Settlement, map_cell: MapCell):
	self.settlement = settlement
	self.map_cell = map_cell
	
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
		if !player.resources.has(result_res):
			player.resources[result_res] = 0
		player.resources[result_res] += resources_to_add[result_res]

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

func get_settlement() -> Settlement:
	return settlement

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
	self.name = content_dict["name"]
	self.type = content_dict["type"]
	self.cost = content_dict["cost"]
	self.max_residents = content_dict["max_residents"]

	for production_option in content_dict["production_options"]:
		var new_production_option
		match production_option["production_type"]:
			Consts.BASE_PRODUCTION:
				new_production_option = BaseProductionOption.new()
				new_production_option.production_per_unit = production_option["production_per_unit"]
				new_production_option.max_production_input_amount = production_option["max_production_input_amount"]
				new_production_option.input_resource_type = ResourceTypes.PRODUCTION_TYPE.get(production_option["input_resource_type"])
		new_production_option.name = production_option["name"]
		new_production_option.description = production_option["description"]
		self.production_options[new_production_option] = null
