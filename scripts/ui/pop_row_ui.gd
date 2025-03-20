class_name PopRowUI extends HBoxContainer

@onready var navigate_button = $NavigateButton
@onready var basic_info = $BasicInfo

var pop: Pop

func render(new_pop: Pop):
	self.pop = new_pop
	navigate_button.text = pop.name
	basic_info.text = pop.get_basic_info()

func _on_navigate_button_pressed():
	print("navigate to pop (not implemented)")
	#SignalBus.select_pop.emit(pop)
