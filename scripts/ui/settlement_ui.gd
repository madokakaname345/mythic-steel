class_name SettlementUI extends Panel

@onready var settlement_info = $VBoxContainer/BasicSettlementInfo
@onready var pops_info = $VBoxContainer/PopsInfoText
@onready var tiles_container = $VBoxContainer/TilesContainer/VBoxContainer

var tile_row_scene = preload("res://scenes/ui/tile_row_ui.tscn")

func _ready():
	pass

func render(selector: Selector):
	settlement_info.clear()
	pops_info.clear()
	for child in tiles_container.get_children():
		tiles_container.remove_child(child)
		child.queue_free()  # Queue the child for deletion		
		
	match selector.selector_type:
		SelectorTypes.SELECTOR_TYPE.SETTLEMENT:
			fill_settlement_info(selector.selected_object)
		_:
			push_error("Incorrect selector type for the settlement ui") # should never happen
	
	pass

func fill_settlement_info(selected_object: Settlement):
	settlement_info.append_text(selected_object.get_ui_data())
	
	var total_workers = 0
	var total_max_workers = 0
	var total_residents = 0
	var total_max_residents = 0

	var tiles = selected_object.get_tiles()
	for tile in tiles:
		var tile_row = tile_row_scene.instantiate()
		tiles_container.add_child(tile_row)
		tile_row.set_biome(str(tile.get_biome()))
		var workers = tile.get_workers_amount()
		var max_workers = tile.get_max_workers_amount()
		var residents = tile.get_residents_amount()
		var max_residents = tile.get_max_residents_amount()
		total_workers += workers
		total_max_workers += max_workers
		total_residents += residents
		total_max_residents += max_residents
		tile_row.set_pops_info(workers, max_workers, residents, max_residents)
		tile_row.set_buttons(tile.get_buildings())

	pops_info.append_text(str("Total Workers: %s/%s, Total Residents: %s/%s" % [total_workers, total_max_workers, total_residents, total_max_residents]))
