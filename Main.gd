extends Node

@export var rack_container: Node

func _ready() -> void:
	get_window().content_scale_factor = TestData.content_scale
	
	var text_display = TextDisplay.new()
	add_child(text_display)
	text_display.text_display.text = ConsolePrinter.run(Upper.run("Hello world!"))
	
	var item_list := Items.new()
	add_child(item_list)
	for i in range(5):
		item_list.item_list.add_item(str(i))
	
	var rack := Rack.new()
	add_child(rack)
	rack.reload(rack_container)
