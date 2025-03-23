class_name BuildingSelectionPanel extends Panel

@onready var buildings_contaner = $VBoxContainer/StructureContainer/VBoxContainer
var player: Player

const structure_row_ui_scene = preload("res://scenes/ui/structure_row_ui.tscn")

func render(new_player: Player):
	self.player = new_player
	for child in buildings_contaner.get_children():
		buildings_contaner.remove_child(child)
		child.queue_free()  # Queue the child for deletion
		
	fill_buildings()

func fill_buildings():
	for building in player.get_available_buildings():
		var structure_row_ui = structure_row_ui_scene.instantiate()
		buildings_contaner.add_child(structure_row_ui)
		structure_row_ui.to_build = true
		structure_row_ui.set_structure(building)
