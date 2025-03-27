class_name PlayerUI extends Panel

@onready var pops_container = $VBoxContainer/PopsContainer/VBoxContainer
@onready var resources_info = $VBoxContainer/ResourcesInfo

var player: Player

var pop_row_scene = preload("res://scenes/ui/pop_row_ui.tscn")

func render(new_player: Player):
	self.player = new_player
	
	resources_info.clear()
	for child in pops_container.get_children():
		pops_container.remove_child(child)
		child.queue_free()  # Queue the child for deletion
		
	fill_resources()
	fill_pops()
	
func fill_resources():
	var resources = player.get_all_resources()
	for resource in resources:
		resources_info.append_text(str("%s: %d\n" % [resource, resources[resource]]))

func fill_pops():
	for pop in player.pops:
		var pop_row = pop_row_scene.instantiate()
		pops_container.add_child(pop_row)
		pop_row.render(pop)
