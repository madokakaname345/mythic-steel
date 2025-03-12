class_name ProductionRowUI extends HBoxContainer

@onready var production_info = $ProductionInfo

func set_production_info(production: String):
	production_info.text = production
