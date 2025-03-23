extends Node

signal update_ui
signal update_tile(coords)
signal settlement_created(settlement)
signal unit_created(unit)
signal pop_created(pop)
signal pop_deleted(pop)
signal process_select(coords)
signal selection_changed(select_object)
signal end_turn

#selector signals
signal select_existing_building(building)
signal select_pop(pop)

signal select_building_to_build(building: Building)

#debug signals
signal toggle_debug_panel
signal toggle_visibility
