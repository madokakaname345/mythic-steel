class_name IronMine extends Building


func _init(settlement: Settlement, map_cell: MapCell):
	super._init(settlement, map_cell)
	name = "Mine"
	cost = {"wood": 50, "stone": 30}
	max_workers = 3
#	workers_required = 5

func can_be_built() -> bool:
	return settlement.get_nearby_resources()[ResourceTypes.IRON_ORE] > 0

func on_turn_end():
	if !settlement.resources.has("iron_ore"):
		settlement.resources["iron_ore"] = 0
	settlement.resources["iron_ore"] += 10*workers.size() + 5
