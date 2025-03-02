extends CanvasLayer

@onready var rich_text_label = $SidePanel/RichTextLabel
@onready var buttons_container = $SidePanel/ButtonsContainer
@onready var end_turn_button = $EndTurnButton
@onready var debug_panel: Panel = $DebugPanel

func render(selector):
	var data
	var buttons
	rich_text_label.clear()
	#buttons_container.clear()
	for child in buttons_container.get_children():
		buttons_container.remove_child(child)
		child.queue_free()  # Queue the child for deletion
	match selector.selector_type:
		SelectorTypes.SELECTOR_TYPE.TILE:
			data = selector.selected_object.get_ui_data()
			buttons = selector.selected_object.get_ui_buttons()
		SelectorTypes.SELECTOR_TYPE.SETTLEMENT:
			data = selector.selected_object.get_ui_data()
			buttons = selector.selected_object.get_ui_buttons()
		SelectorTypes.SELECTOR_TYPE.UNIT:
			data = selector.selected_object.get_ui_data()
			buttons = selector.selected_object.get_ui_buttons()
		SelectorTypes.SELECTOR_TYPE.SETTLEMENT_TILE:
			data = selector.selected_object.get_ui_data()
			buttons = selector.selected_object.get_ui_buttons()		
		SelectorTypes.SELECTOR_TYPE.NONE:
			data = ""
			buttons = []
		_:
			push_error("Selector: unknown selector type") # should never happen
	
	rich_text_label.append_text(data)
		
	for button in buttons:
		buttons_container.add_child(button)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		pass

func _on_end_turn_button_pressed():
	SignalBus.end_turn.emit()


func _on_toggle_tiles_visibility_pressed():
	SignalBus.toggle_visibility.emit()

func _on_debub_panel_button_pressed():
	debug_panel.set_visible(!debug_panel.is_visible())
