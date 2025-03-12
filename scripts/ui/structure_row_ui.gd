class_name StructureRowUI extends HBoxContainer

@onready var structure_navi_button = $StructureNaviButton
@onready var pops_info = $PopsInfo

var structure: Building

func set_structure(structure: Building):
	self.structure = structure
	configure_navigatable_button(self.structure.get_name())
	set_pops_info(self.structure.get_workers().size(), self.structure.get_max_workers(), self.structure.get_residents().size(), self.structure.get_max_residents())

func configure_navigatable_button(name: String):
	structure_navi_button.text = name
	structure_navi_button.pressed.connect(Callable(self, "navigate_button_pressed"))

func set_pops_info(workers: int, max_workers: int, residents: int, max_residents: int):
	pops_info.text = str("Workers: %s/%s, Residents: %s/%s" % [workers, max_workers, residents, max_residents])

func navigate_button_pressed():
	SignalBus.select_building.emit(structure)
