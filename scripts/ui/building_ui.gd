class_name BuildingUI extends Panel

@onready var building_info = $VBoxContainer/BuildingInfo
@onready var building_type = $VBoxContainer/BuildingType
@onready var production_info = $VBoxContainer/ProductionContainer/VBoxContainer

@onready var resources_container = $VBoxContainer/ResourcesContainer/VBoxContainer

var production_row_scene = preload("res://scenes/ui/production_row_ui.tscn")
var resource_row_scene = preload("res://scenes/ui/resource_row_ui.tscn")

var building: Building

func _ready():
	pass

func render(selector: Selector):
	for child in resources_container.get_children():
		resources_container.remove_child(child)
		child.queue_free()
	
	for child in production_info.get_children():
		production_info.remove_child(child)
		child.queue_free()  # Queue the child for deletion		
		
	match selector.selector_type:
		SelectorTypes.SELECTOR_TYPE.BUILDING:
			fill_building_info(selector.selected_object)
		_:
			push_error("Incorrect selector type for the settlement ui") # should never happen
	
	pass

func fill_building_info(selected_object: Building):
	self.building = selected_object
	
	building_info.append_text(selected_object.get_ui_data())
	building_type.append_text(selected_object.get_type())

	var production_options = selected_object.get_production_options()
	for production_option in production_options:
		var production_option_row = production_row_scene.instantiate()
		production_info.add_child(production_option_row)
		production_option_row.set_production_info(str("%s %s" % [production_option.get_name(), production_option.get_ui_data()]))
		production_option_row.prepare_assignment_options(selected_object, production_option)
		
	# resources_container
	var resources = self.building.stock

	for res_name in resources.keys():
		var res_row = resource_row_scene.instantiate()
		resources_container.add_child(res_row)
		res_row.set_res_name(res_name)
		res_row.set_res_amount(resources[res_name])
		
