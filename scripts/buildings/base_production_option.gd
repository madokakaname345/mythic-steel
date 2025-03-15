class_name BaseProductionOption extends GenericProductionOption

var input_resource_type = ResourceTypes.PRODUCTION_TYPE
var production_per_unit = {}
var max_production_input_amount = 0


func get_ui_data() -> String:
	var result = ""
	for key in production_per_unit.keys():
		result += str("%s:%d," % [key, production_per_unit[key]])
	return str("%s -> (%s). Max input = %d" % [name, result, max_production_input_amount])
