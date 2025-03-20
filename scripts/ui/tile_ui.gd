class_name TileUI extends Panel

@onready var buttons_container = $VBoxContainer/ButtonsContainer/VBoxContainer
@onready var resources_container = $VBoxContainer/ResourcesContainer/VBoxContainer
@onready var structures_container = $VBoxContainer/StructureContainer/VBoxContainer
@onready var tile_info = $VBoxContainer/TileInfo

var resource_row_scene = preload("res://scenes/ui/resource_row_ui.tscn")
var structure_row_scene = preload("res://scenes/ui/structure_row_ui.tscn")

func _ready():
	pass

func render(selector: Selector):
	tile_info.clear()
	for child in buttons_container.get_children():
		buttons_container.remove_child(child)
		child.queue_free()  # Queue the child for deletion
	for child in resources_container.get_children():
		resources_container.remove_child(child)
		child.queue_free()  # Queue the child for deletion
	for child in structures_container.get_children():
		structures_container.remove_child(child)
		child.queue_free()  # Queue the child for deletion
		
		
	match selector.selector_type:
		SelectorTypes.SELECTOR_TYPE.TILE:
			fill_tile_info(selector.selected_object)
		_:
			push_error("Incorrect selector type for the tile ui") # should never happen
	pass

func fill_tile_info(selected_object: MapCell):
	tile_info.append_text(selected_object.get_ui_data())
	var resources = selected_object.get_resources()
		
	for res_name in resources.keys():
		var res_row = resource_row_scene.instantiate()
		resources_container.add_child(res_row)
		res_row.set_res_name(res_name)
		res_row.set_res_amount(resources[res_name])

	var building = selected_object.get_building()
	if building != null:
		var building_row = structure_row_scene.instantiate()
		structures_container.add_child(building_row)
		building_row.set_structure(building)
	
	var buttons = selected_object.get_ui_buttons()
	for button in buttons:
		buttons_container.add_child(button)
	
