class_name Main extends Node2D

var curr_selected_obj
@onready var ui = get_node("UI")
@onready var selector = get_node("Selector")
@onready var map_camera = get_node("MapCamera")
@onready var tile_map_layers = get_node("TileMapLayers")
var blink_timer = 0
var blink_on = true
var blink_interval = 0.5

var curr_turn = 1
var settlements = []

func _ready():
	SignalBus.update_ui.connect(upd_ui)
	SignalBus.update_tile.connect(upd_map)
	SignalBus.settlement_created.connect(add_settlement)
	SignalBus.end_turn.connect(end_turn)

func upd_ui():
	ui.render(curr_selected_obj)
	
func upd_map(coords):
	tile_map_layers.update_tile(coords)

func _process(delta):
	blink_timer += delta
	if blink_timer >= blink_interval:
		blink_timer = 0
		if curr_selected_obj != null:
			selector.visible = blink_on
			blink_on = !blink_on
			
func add_settlement(settlement):
	settlements.append(settlement)

func end_turn():
	#make a transation
	for i in settlements.size():
		var s = settlements[i]
		s.end_turn()
	ui.end_turn_button.text = str("End Turn %s" % curr_turn)
