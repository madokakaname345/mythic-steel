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

var player: Player

var resources_info = {}

func _ready():
	# connect signals
	SignalBus.update_ui.connect(upd_ui)
	SignalBus.update_tile.connect(upd_tile)
	SignalBus.unit_created.connect(add_unit)
	SignalBus.end_turn.connect(end_turn)
	SignalBus.toggle_visibility.connect(toggle_visibility)
	SignalBus.process_select.connect(process_select)
	SignalBus.select_existing_building.connect(select_existing_building)
	SignalBus.select_building_to_build.connect(select_building_to_build)

	# add main to some classes
	ui.main = self
	player = Player.new(self)

	load_resources_info()
	
func select_existing_building(building):
	selector.selector_type = SelectorTypes.SELECTOR_TYPE.BUILDING
	selector.selected_object = building
	ui.render(selector)

func select_building_to_build(building):
	if selector.selector_type == SelectorTypes.SELECTOR_TYPE.TILE:
		selector.selected_object.create_building(building)
		ui.render(selector)


func upd_ui():
	ui.render(selector)
	# tile_map_layers.update_highlighted_tiles(selector)

func upd_tile(coords):
	tile_map_layers.update_tile(coords)

func upd_map(_coords):
	tile_map_layers.update_map()

func get_world_map():
	return tile_map_layers.world_map

func get_terrain_layer():
	return tile_map_layers.terrain_layer

func _process(delta):
	pass

func add_unit(unit):
	units.append(unit)
	selector.selector_type = SelectorTypes.SELECTOR_TYPE.UNIT
	selector.selected_object = unit
	ui.render(selector)

func end_turn():
	#make a transation
	#for i in settlements.size():
		#var s = settlements[i]
		#s.end_turn()
	#for i in units.size():
		#var u = units[i]
		#u.end_turn()
	player.end_turn()
	ui.end_turn_button.text = str("End Turn %s" % curr_turn)
	upd_ui()

func get_resources_in_radius(r: int, coords: Vector2i):
	return tile_map_layers.get_resources_in_radius(r, coords)

func toggle_visibility():
	#upd global visibility + redraw terrain
	tile_map_layers.toggle_global_visibility(true)

func get_tile_map_layers() -> TileMapLayers:
	return tile_map_layers

func process_select(coords):
	selector.select_object(coords)
	ui.render(selector)	

func get_player() -> Player:
	return player

func load_resources_info():
	var content = FileAccess.open("res://data/resources.json", FileAccess.READ).get_as_text()
	self.resources_info = JSON.parse_string(content)

func get_res_info(res_name: String):
	return resources_info[res_name]
