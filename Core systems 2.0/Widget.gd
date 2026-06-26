extends RefCounted
class_name Widget

var _layout: VBoxContainer

func create(minimum_size: int = 200) -> void:
	if _layout == null:
		_layout = VBoxContainer.new()
		_layout.custom_minimum_size = Vector2i(minimum_size, 0)

func append_custom_controls(node: Node, size: int = 1) -> void:
	if _layout == null:
		push_error("Trying to append controls on widget that wasn't created with \"widget.create()\"")
		return
	if is_instance_of(node, HBoxContainer):
		_layout.add_child(node)
	else:
		var hbox := HBoxContainer.new()
		hbox.custom_minimum_size = Vector2i(0, 50*size)
		hbox.add_child(node)
		_layout.add_child(hbox)
