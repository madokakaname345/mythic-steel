extends Node

signal update_ui
signal update_tile(coords)
signal settlement_created(settlement)
signal unit_created(unit)
signal pop_created(pop)
signal pop_deleted(pop)
signal end_turn


#debug signals
signal toggle_debug_panel
signal toggle_visibility
