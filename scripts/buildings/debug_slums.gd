class_name DebugSlums extends Building


func _init(settlement: Settlement, map_cell: MapCell):
	super._init(settlement, map_cell)
	name = "Debug Slums"
	cost = {}
	max_workers = 0
	max_residents = 2

func can_be_built() -> bool:
	return true

func on_turn_end():
	pass
