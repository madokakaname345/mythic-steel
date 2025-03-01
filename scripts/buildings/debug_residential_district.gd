class_name DebugResidentialDistrict extends Building


func _init(settlement: Settlement, map_cell: MapCell):
	super._init(settlement, map_cell)
	name = "Debug Residential Building"
	cost = {"bmats": 10}
	max_workers = 0
	max_residents = 3

func can_be_built() -> bool:
	return true

func on_turn_end():
	pass
