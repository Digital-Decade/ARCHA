extends Node

@export var rack_container: Node
@export var panels: Array[Script]

func _ready() -> void:
	get_window().content_scale_factor = TestData.content_scale
	
	var rack := Rack.new()
	add_child(rack)
	rack.reload(rack_container, panels)
