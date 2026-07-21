extends RefCounted
class_name Drawer

var drawer: Node
var _active_widgets: Dictionary = {}

func create(drawer_container: Node) -> void:
	drawer = HBoxContainer.new()
	drawer_container.add_child(drawer)

func add_widget(widget: Widget, nodule_id: int) -> void:
	if widget._layout != null:
		drawer.add_child(widget._layout)
		_active_widgets.set(nodule_id, widget)
	
func drop_widget(index_of_target: int) -> void:
	_active_widgets.get(index_of_target).queue_free()

func clear() -> void:
	for child in drawer.get_children():
		child.queue_free()
