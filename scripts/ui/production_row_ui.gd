class_name ProductionRowUI extends HBoxContainer

@onready var production_info = $ProductionInfo
@onready var assignment_options = $AssignmentButton

var focuses = {}

func set_production_info(production: String):
	production_info.text = production

func prepare_assignment_options(building: Building):
	assignment_options.clear()
	focuses = {0: "NONE"}
	assignment_options.add_item("NONE", 0)
	var available_pop_groups = building.get_settlement().get_available_pops_to_assign()
	var i = 0
	for pop_group in available_pop_groups:
		i =+ 1
		assignment_options.add_item(str("%s %d" % [pop_group, available_pop_groups[pop_group].size()]), i)
		focuses[i] = pop_group


func _on_assignment_button_item_focused(index):
	pass # Replace with function body.


func _on_assignment_button_item_selected(index):
	print("selected", focuses[index])
