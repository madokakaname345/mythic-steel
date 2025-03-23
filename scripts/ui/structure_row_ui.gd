class_name StructureRowUI extends HBoxContainer

@onready var structure_navi_button = $StructureNaviButton
@onready var pops_info = $PopsInfo
@onready var price_info = $PriceInfo

var to_build: bool
var structure: Building

func set_structure(structure: Building):
	pops_info.clear()
	pops_info.set_visible(false)
	price_info.clear()
	price_info.set_visible(false)
	self.structure = structure
	configure_navigatable_button(self.structure.get_name())
	if !to_build: 
		set_pops_info(self.structure.get_workers().size(), self.structure.get_max_workers(), self.structure.get_residents().size(), self.structure.get_max_residents())
	else:
		set_price_info()

func configure_navigatable_button(name: String):
	structure_navi_button.text = name
	structure_navi_button.pressed.connect(Callable(self, "navigate_button_pressed"))

func set_pops_info(workers: int, max_workers: int, residents: int, max_residents: int):
	pops_info.set_visible(true)
	pops_info.text = str("Workers: %s/%s, Residents: %s/%s" % [workers, max_workers, residents, max_residents])
	
func set_price_info():
	price_info.set_visible(true)
	for res in structure.cost:
			price_info.append_text(str("%s: %d" % [res, structure.cost[res]]))

func navigate_button_pressed():
	if !to_build:
		SignalBus.select_existing_building.emit(structure)
	else:
		SignalBus.select_building_to_build.emit(structure)
