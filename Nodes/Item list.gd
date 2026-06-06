extends Node
class_name Items

var item_list: ItemList

func _ready() -> void:
	var root_node = get_window()
	item_list = root_node.get_node("Root/VBoxContainer/PanelContainer2/PanelContainer/HBoxContainer/VBoxContainer3/ItemList")
	item_list.add_item("hi")
