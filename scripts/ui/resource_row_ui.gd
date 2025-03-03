class_name ResourceRowUI extends HBoxContainer

@onready var resource_name = $ResName
@onready var resource_amount = $ResAmount

func set_res_name(name: String):
	resource_name.text = name

func set_res_amount(amount: int):
	resource_amount.text = str(amount)
