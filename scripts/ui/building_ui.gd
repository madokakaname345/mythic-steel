class_name BuildingUI extends Panel

@onready var building_info = $VBoxContainer/BuildingInfo
@onready var settlement_info = $VBoxContainer/SettlementInfo
@onready var building_type = $VBoxContainer/BuildingType
@onready var production_info = $VBoxContainer/ProductionContainer/VBoxContainer

var production_row_scene = preload("res://scenes/ui/production_row_ui.tscn")

func _ready():
	pass

func render(selector: Selector):
	settlement_info.clear()
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
	settlement_info.append_text(selected_object.get_settlement().get_ui_data())
	building_info.append_text(selected_object.get_ui_data())
	building_type.append_text(selected_object.get_type())

	var production_options = selected_object.get_production_options()
	for production_option in production_options:
		var production_option_row = production_row_scene.instantiate()
		production_info.add_child(production_option_row)
		production_option_row.set_production_info(str("%s %s" % [production_option.get_name(), production_option.get_ui_data()]))
		production_option_row.prepare_assignment_options(selected_object, production_option)
		
