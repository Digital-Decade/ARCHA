extends Nodule

static func setup(ports: Ports, _widget: Widget) -> void:
	var widget_scene: PackedScene = load("res://User/Nodules/File system selector/File system selector.tscn")
	var widget_instance: Node = widget_scene.instanciate()
	_widget.assign(widget_instance)
	var button: Button
	var path: LineEdit
	ports.open_input("Directory", TYPE_STRING)
	ports.open_output("Files", TYPE_PACKED_STRING_ARRAY)
	ports.create_ui_emitter(1, button, &"pressed", 0)
	
static func function(packet: Packet) -> void:
	pass
