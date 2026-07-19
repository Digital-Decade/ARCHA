extends RefCounted
class_name Drawer

static func create(drawer_container: Node) -> Node:
	var drawer := HBoxContainer.new()
	drawer_container.add_child(drawer)
	return drawer

static func add_widget(drawer: Node, widget: Widget) -> void:
	if widget._layout != null:
		drawer.add_child(widget._layout)
	
static func drop_widget(drawer: Node, index_of_target: int) -> void:
	drawer.get_child(index_of_target).queue_free()

static func clear(drawer: Node) -> void:
	for child in drawer.get_children():
		child.queue_free()
		
static func refresh(drawer: Node, widgets: Array[Widget]) -> void:
	clear(drawer)
	for widget in widgets:
		add_widget(drawer, widget)
