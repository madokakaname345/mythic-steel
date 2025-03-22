class_name Player

var resources = {}
var buildings: Array[Building] = []
var pops: Array[Pop] = []


func get_free_res_building():
	# get through every building and look for free residende slots
	for building in buildings:
		if building.max_residents > building.residents.size():
			return building
	# if no free res slots - return null
	return null
	
func end_turn():
	for building in buildings:
		building.on_turn_end()

func get_available_pops_for_production_option(prod_option: GenericProductionOption) -> Array:
	var available_pops = []
	for pop in pops:
		if pop.can_be_assigned_to(prod_option):
			available_pops.append(pop)
	return available_pops
