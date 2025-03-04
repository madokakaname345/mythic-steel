class_name UnitUI extends Panel

@onready var unit_info = $VBoxContainer/BasicUnitInfo

func render(selector: Selector):
	unit_info.clear()
		
	match selector.selector_type:
		SelectorTypes.SELECTOR_TYPE.UNIT:
			fill_unit_info(selector.selected_object)
		_:
			push_error("Incorrect selector type for the settlement ui") # should never happen
	
	pass

func fill_unit_info(selected_object: Unit):
	unit_info.append_text(str("Name: %s,\n Type: %s,\n Max Movement: %d,\n Curr Movement: %d\n" % [selected_object.get_name(), 
	selected_object.get_type(),
	selected_object.get_max_movement_points(),
	selected_object.get_curr_movement_points()]))
