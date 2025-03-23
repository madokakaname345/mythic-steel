extends CanvasLayer

@onready var side_panel: Panel = $SidePanel
@onready var end_turn_button = $EndTurnButton
@onready var debug_panel: Panel = $DebugPanel
@onready var additional_panel: Panel = $AdditionalPanel

var tile_ui = preload("res://scenes/ui/tile_ui.tscn")
var building_ui = preload("res://scenes/ui/building_ui.tscn")
var player_ui = preload("res://scenes/ui/player_ui.tscn")

var building_selection_panel_scene = preload("res://scenes/ui/buildings_selection_panel.tscn")
	
var main: Main

func render(selector):
	render_main_panel(selector)
	render_additional_panel(selector)

	main.get_tile_map_layers().update_highlighted_tiles(selector)
	main.get_tile_map_layers().update_map()

func render_main_panel(selector):
	var data
	var buttons

	for child in side_panel.get_children():
		side_panel.remove_child(child)
		child.queue_free()  # Queue the child for deletion

	match selector.selector_type:
		SelectorTypes.SELECTOR_TYPE.TILE:
			var tile_ui_instance = tile_ui.instantiate()
			side_panel.add_child(tile_ui_instance)
			tile_ui_instance.render(selector)
		SelectorTypes.SELECTOR_TYPE.BUILDING:
			var building_ui_instance = building_ui.instantiate()
			side_panel.add_child(building_ui_instance)
			building_ui_instance.render(selector)
		SelectorTypes.SELECTOR_TYPE.NONE:
			var player_ui_instance = player_ui.instantiate()
			side_panel.add_child(player_ui_instance)
			player_ui_instance.render(main.player)
		_:
			push_error("Selector: unknown selector type") # should never happen

func render_additional_panel(selector):
	for child in additional_panel.get_children():
		additional_panel.remove_child(child)
		child.queue_free()  # Queue the child for deletion
		additional_panel.set_visible(false)
	
	match selector.additional_selector_type:
		SelectorTypes.ADDITIONAL_SELECTOR_TYPE.NONE:
			pass
		SelectorTypes.ADDITIONAL_SELECTOR_TYPE.AVAILABLE_BUILDINGS_TO_BUILD:
			additional_panel.set_visible(true)
			if selector.selector_type != SelectorTypes.SELECTOR_TYPE.TILE:
				pass
			var building_selection_panel = building_selection_panel_scene.instantiate()
			additional_panel.add_child(building_selection_panel)
			building_selection_panel.render(main.get_player())
		_:
			pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		pass

func _on_end_turn_button_pressed():
	SignalBus.end_turn.emit()


func _on_toggle_tiles_visibility_pressed():
	SignalBus.toggle_visibility.emit()

func _on_debub_panel_button_pressed():
	debug_panel.set_visible(!debug_panel.is_visible())

func _on_show_info_button_pressed():
	side_panel.set_visible(!side_panel.is_visible())
