extends Control

const GODOT_ICON = preload("res://Assets/icon.svg")
@onready var item_list: ItemList = $HBoxContainer/ItemList



func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	item_list.max_columns = 0
	item_list.fixed_icon_size = Vector2i(32, 32)
	item_list.add_item("aaa", GODOT_ICON)
	item_list.add_item("hey")
	
	


func _on_button_pressed() -> void:
	var text_edit: TextEdit = get_node("HBoxContainer/VBoxContainer/TextEdit")
	text_edit.text
