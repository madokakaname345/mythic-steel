class_name IronMine extends Building


func _init(settlement: Settlement):
	super._init(settlement)
	name = "Mine"
	cost = {"wood": 50, "stone": 30}
	workers_required = 5

func can_be_built() -> bool:
	return settlement.get_nearby_resources()[ResourceTypes.IRON_ORE] > 0

func on_turn_end():
	if !settlement.resources.has("iron_ore"):
		settlement.resources["iron_ore"] = 0
	settlement.resources["iron_ore"] += 10
