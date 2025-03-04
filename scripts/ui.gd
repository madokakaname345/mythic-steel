extends CanvasLayer

@onready var side_panel: Panel = $SidePanel
@onready var end_turn_button = $EndTurnButton
@onready var debug_panel: Panel = $DebugPanel

var tile_ui = preload("res://scenes/ui/tile_ui.tscn")
var settlement_ui = preload("res://scenes/ui/settlement_ui.tscn")
	

func render(selector):
	var data
	var buttons

	for child in side_panel.get_children():
		side_panel.remove_child(child)
		child.queue_free()  # Queue the child for deletion

	match selector.selector_type:
		SelectorTypes.SELECTOR_TYPE.TILE:
			# data = selector.selected_object.get_ui_data()
			# buttons = selector.selected_object.get_ui_buttons()
			var tile_ui_instance = tile_ui.instantiate()
			side_panel.add_child(tile_ui_instance)
			tile_ui_instance.render(selector)
		SelectorTypes.SELECTOR_TYPE.SETTLEMENT:
			var settlement_ui_instance = settlement_ui.instantiate()
			side_panel.add_child(settlement_ui_instance)
			settlement_ui_instance.render(selector)
		SelectorTypes.SELECTOR_TYPE.UNIT:
			data = selector.selected_object.get_ui_data()
			buttons = selector.selected_object.get_ui_buttons()
		SelectorTypes.SELECTOR_TYPE.SETTLEMENT_TILE:
			var tile_ui_instance = tile_ui.instantiate()
			side_panel.add_child(tile_ui_instance)
			tile_ui_instance.render(selector)
		SelectorTypes.SELECTOR_TYPE.NONE:
			data = ""
			buttons = []
		_:
			push_error("Selector: unknown selector type") # should never happen

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
