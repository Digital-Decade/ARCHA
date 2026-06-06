extends Node
class_name Rack

var rack := HBoxContainer.new()
var modules := ["print output", "file picker", "list view"]

func _ready() -> void:
	for module in modules:
		var panel := VBoxContainer.new()
		panel.custom_minimum_size = Vector2i(200, 0)
		rack.add_child(panel)
	var rack_container := get_window().get_node("Root/VBoxContainer/PanelContainer2/PanelContainer")
	for child in rack_container.get_children():
		child.queue_free()
	rack_container.add_child(rack)
