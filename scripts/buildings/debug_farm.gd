class_name DebugFarm extends Building


func _init(settlement: Settlement, map_cell: MapCell):
	super._init(settlement, map_cell)
	name = "Debug Farm"
	cost = {"bmats": 10}
	max_workers = 3
#	workers_required = 5

func can_be_built() -> bool:
	return true

func on_turn_end():
	if !settlement.resources.has("food"):
		settlement.resources["food"] = 0
	settlement.resources["food"] += 10*workers.size() + 5
