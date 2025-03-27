class_name HaulingProductionOption extends GenericProductionOption

var type = ResourceTypes.HAULING_TYPE.NONE
var assignee: Pop = null

func get_ui_data() -> String:
	match type: 
		ResourceTypes.HAULING_TYPE.NONE:
			return str("None")
		ResourceTypes.HAULING_TYPE.COLLECT_ALL_TO:
			return str("Collect all to")
		_:
			return str("Unknown type")
