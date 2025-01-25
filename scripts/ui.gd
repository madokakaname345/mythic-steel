extends CanvasLayer

@onready var rich_text_label = $SidePanel/RichTextLabel
@onready var buttons_container = $SidePanel/ButtonsContainer

func render(selected_obj):
	var data = selected_obj.get_ui_data() # string
	var buttons = selected_obj.get_ui_buttons() #array of buttons
	
	rich_text_label.clear()
	rich_text_label.append_text(data)
	
	for child in buttons_container.get_children():
		buttons_container.remove_child(child)
		child.queue_free()  # Queue the child for deletion
		
	for button in buttons:
		buttons_container.add_child(button)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		pass
