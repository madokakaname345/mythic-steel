class_name StructureRowUI extends HBoxContainer

@onready var structure_name = $StructureName
@onready var pops_info = $PopsInfo
@onready var navigate_button = $NavigateButton

func set_structure_name(name: String):
	structure_name.text = name

func set_pops_info(workers: int, max_workers: int, residents: int, max_residents: int):
	pops_info.text = str("Workers: %s/%s, Residents: %s/%s" % [workers, max_workers, residents, max_residents])

func set_navigate_button_text(text: String):
	navigate_button.text = "icon.png(not implemented)"
