class_name Main extends Node2D

var selector = Selector.new(self)

@onready var ui = get_node("UI")
#@onready var selector = get_node("Selector")
@onready var map_camera = get_node("MapCamera")
@onready var tile_map_layers = get_node("TileMapLayers")
var blink_timer = 0
var blink_on = true
var blink_interval = 0.5

var curr_turn = 1
var settlements = []
var units = []

func _ready():
	SignalBus.update_ui.connect(upd_ui)
	SignalBus.update_tile.connect(upd_map)
	SignalBus.settlement_created.connect(add_settlement)
	SignalBus.unit_created.connect(add_unit)
	SignalBus.end_turn.connect(end_turn)
	SignalBus.toggle_visibility.connect(toggle_visibility)
	SignalBus.process_select.connect(process_select)

func upd_ui():
	ui.render(selector)
	tile_map_layers.update_highlighted_tiles(selector)
	
func upd_map(coords):
	tile_map_layers.update_tile(coords)

func get_world_map():
	return tile_map_layers.world_map

func get_terrain_layer():
	return tile_map_layers.terrain_layer

func _process(delta):
	pass
			
func add_settlement(settlement):
	settlements.append(settlement)

func add_unit(unit):
	units.append(unit)

func end_turn():
	#make a transation
	for i in settlements.size():
		var s = settlements[i]
		s.end_turn()
	for i in units.size():
		var u = units[i]
		u.end_turn()
	ui.end_turn_button.text = str("End Turn %s" % curr_turn)

func get_resources_in_radius(r: int, coords: Vector2i):
	return tile_map_layers.get_resources_in_radius(r, coords)

func toggle_visibility():
	#upd global visibility + redraw terrain
	tile_map_layers.toggle_global_visibility(true)

func process_select(coords):
	selector.select_object(coords)
	ui.render(selector)	
