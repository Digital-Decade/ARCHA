extends RefCounted
class_name Widget

var _layout: VBoxContainer
var push_adresses: Array
var grab_adresses: Array

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


class FinishSignal:
	var _object_reference: Node
	var _signal_name: StringName
	func _init(object_reference: Node, signal_name: StringName) -> void:
		_object_reference = object_reference
		_signal_name = signal_name

class ObjectProperty:
	var _object_reference: Node
	var _property_name: StringName
	func _init(object_reference: Node, property_name: StringName) -> void:
		_object_reference = object_reference
		_property_name = property_name


func create_ui_receiver(property: ObjectProperty):
	pass

func create_ui_emmiter():
	pass
	



func bind_to(port: Ports.Port) -> void:
	pass


func set_ui_receiver(
	out_port_to_push_from: Ports.Port, 
	ui_object_reference: Node, 
	ui_property_name: StringName
) -> void:
	var address := ObjectProperty.new(ui_object_reference, ui_property_name)

func set_ui_emmiter(
	ui_object_reference: Node, 
	change_signal: StringName
) -> void:
	ui_object_reference.connect(change_signal, Orchestrator.summon)
