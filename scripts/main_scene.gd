class_name Main extends Node2D

var curr_selected_obj
@onready var ui = get_node("/root/MainScene/UI")

func _ready():
	SignalBus.update_ui.connect(upd_ui)

func upd_ui():
	ui.render(curr_selected_obj)
