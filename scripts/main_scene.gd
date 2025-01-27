class_name Main extends Node2D

var curr_selected_obj
@onready var ui = get_node("/root/MainScene/UI")
@onready var selector = get_node("/root/MainScene/Selector")
@onready var map_camera = get_node("/root/MainScene/MapCamera")
var blink_timer = 0
var blink_on = true
var blink_interval = 0.5

func _ready():
	SignalBus.update_ui.connect(upd_ui)

func upd_ui():
	ui.render(curr_selected_obj)

func _process(delta):
	blink_timer += delta
	if blink_timer >= blink_interval:
		blink_timer = 0
		if curr_selected_obj != null:
			selector.visible = blink_on
			blink_on = !blink_on
			
