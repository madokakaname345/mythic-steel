class_name ProductionRowUI extends HBoxContainer

@onready var production_info = $ProductionInfo
@onready var assignment_options = $AssignmentButton
@onready var assigned_pop_button = $AssignedPopButton
var production_option

var focuses = {}

func set_production_info(production: String):
	production_info.text = production

func prepare_assignment_options(building: Building, production_option):
	if production_option.assigned_pop != null:
		assigned_pop_button.set_visible(true)
		assignment_options.set_visible(false)
		assigned_pop_button.set_text(production_option.assigned_pop.get_assignment_group())
	else:
		assigned_pop_button.set_visible(false)
		assignment_options.set_visible(true)
	self.production_option = production_option
	assignment_options.clear()
	focuses = {0: ["NONE", null]}
	assignment_options.add_item("NONE", 0)
	var available_pop_groups = building.get_settlement().get_available_pops_to_assign()
	var i = 0
	for pop_group in available_pop_groups:
		i =+ 1
		assignment_options.add_item(str("%s %d" % [pop_group, available_pop_groups[pop_group].size()]), i)
		focuses[i] = [pop_group, available_pop_groups[pop_group]]


func _on_assignment_button_item_focused(index):
	pass # Replace with function body.


func _on_assignment_button_item_selected(index):
	print("selected", focuses[index][0])
	if focuses[index][0] == "NONE":
		production_option.assign_pop(null)
	else:
		production_option.assign_pop(focuses[index][1][0])
		assigned_pop_button.set_text(str("assigned pop: %s" % focuses[index][0]))
		assigned_pop_button.set_visible(true)
		assignment_options.set_visible(false)
	


func _on_assigned_pop_button_pressed():
	if production_option.assigned_pop != null:
		production_option.assign_pop(null)
		assigned_pop_button.set_visible(false)
		assignment_options.set_visible(true)
