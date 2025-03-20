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
		assigned_pop_button.set_text(production_option.assigned_pop.name)
	else:
		assigned_pop_button.set_visible(false)
		assignment_options.set_visible(true)
	self.production_option = production_option
	assignment_options.clear()
	focuses = {0: null}
	assignment_options.add_item("NONE", 0)
	var available_pops = building.get_player().pops
	var i = 0
	for pop in available_pops:
		i += 1
		assignment_options.add_item(str("%s" % pop.name), i)
		focuses[i] = pop


func _on_assignment_button_item_focused(index):
	pass # Replace with function body.


func _on_assignment_button_item_selected(index):
	print("selected", focuses[index])
	if focuses[index] == null:
		production_option.assign_pop(null)
	else:
		production_option.assign_pop(focuses[index])
		assigned_pop_button.set_text(focuses[index].name)
		assigned_pop_button.set_visible(true)
		assignment_options.set_visible(false)
	


func _on_assigned_pop_button_pressed():
	if production_option.assigned_pop != null:
		production_option.assign_pop(null)
		assigned_pop_button.set_visible(false)
		assignment_options.set_visible(true)
