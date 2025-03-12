class_name Building

var name: String
var type: String

var cost: Dictionary
var build_progress: int

var production_options: Array[ProductionOption]

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
	pass  # Default: No effect

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

func get_production_options() -> Array[ProductionOption]:
	return production_options

func load(file_name: String):
	var content = FileAccess.open(file_name, FileAccess.READ).get_as_text()
	var content_dict = JSON.parse_string(content)
	self.name = content_dict["name"]
	self.type = content_dict["type"]
	self.cost = content_dict["cost"]

	for production_option in content_dict["production_options"]:
		var new_production_option = ProductionOption.new()
		new_production_option.name = production_option["name"]
		new_production_option.description = production_option["description"]
		new_production_option.input = production_option["input"]
		new_production_option.output = production_option["output"]
		self.production_options.append(new_production_option)
