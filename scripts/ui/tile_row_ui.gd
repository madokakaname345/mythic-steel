class_name TileRowUI extends HBoxContainer

@onready var biome = $Biome
@onready var pops_info = $PopsInfo
@onready var structures_container = $StructuresContainer/HBoxContainer

func set_biome(name: String):
	biome.text = name

func set_pops_info(workers: int, max_workers: int, residents: int, max_residents: int):
	pops_info.text = str("Workers: %s/%s, Residents: %s/%s" % [workers, max_workers, residents, max_residents])

func set_buttons(structures: Array):
	for structure in structures_container.get_children():
		structures_container.remove_child(structure)
		structure.queue_free()  # Queue the child for deletion

	for structure in structures:
		var structure_button = Button.new()
		structure_button.add_child(structure_button)
		structure_button.set_text("Navigate")
