extends RefCounted
class_name Drawer

static func create(drawer_container: Node) -> Node:
	var drawer := HBoxContainer.new()
	drawer_container.add_child(drawer)
	return drawer

static func add_widget(drawer: Node, nodule: Script) -> void:
	var widget := VBoxContainer.new()
	widget.custom_minimum_size = Vector2i(200, 0)
	for strip in nodule.widget():
		widget.add_child(strip)
	drawer.add_child(widget)
	
static func drop_widget(drawer: Node, index_of_target: int) -> void:
	drawer.get_child(index_of_target).queue_free()

static func clear(drawer: Node) -> void:
	for child in drawer.get_children():
		child.queue_free()
		
static func refresh(drawer: Node, nodules: Array[Script]) -> void:
	clear(drawer)
	for nodule in nodules:
		add_widget(drawer, nodule)
