extends RefCounted
class_name Ports

var _inputs: Array[Port] = []
var _outputs: Array[Port] = []
var _widget_inputs: Array[UIPropertyAddress] = []
var _widget_outputs: Array[UIPropertyAddress] = []


class Port:
	var _label: String
	var _type: Variant.Type
	
	func _init(label: String, type: Variant.Type) -> void:
		_label = label
		_type = type


class UIPropertyAddress:
	var _object_reference: Node
	var _property_name: StringName
	var _label: String
	var _type: Variant.Type
	
	func _init(object_reference: Node, property_name: StringName, label: String) -> void:
		_object_reference = object_reference
		_property_name = property_name
		_label = label
		_type = typeof(object_reference.get(property_name))

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


func open_input(label: StringName, type: int) -> Port:
	var port := Port.new(label, type)
	_inputs.append(port)
	return port

func open_output(label: StringName, type: int) -> Port:
	var port := Port.new(label, type)
	_outputs.append(port)
	return port


func create_ui_receiver(
	out_port_to_push_from: Port, 
	ui_object_reference: Node, 
	ui_property_name: StringName
) -> void:
	var address := ObjectProperty.new(ui_object_reference, ui_property_name)

func create_ui_emitter(
	ui_object_reference: Node, 
	change_signal: StringName
) -> void:
	ui_object_reference.connect(change_signal, Orchestrator.static_func_bro)
