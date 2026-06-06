extends Node
class_name TextDisplay

var text_display: RichTextLabel

func _ready() -> void:
	var root_node = get_window()
	text_display = root_node.get_node("Root/VBoxContainer/PanelContainer2/PanelContainer/HBoxContainer/VBoxContainer2/RichTextLabel")
	
