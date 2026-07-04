extends Resource
class_name Ports


var _inputs: Array[Port] = []
var _outputs: Array[Port] = []


class Port:
	var _label: String
	var _type: Variant.Type
	
	func _init(label: String, type: Variant.Type) -> void:
		_label = label
		_type = type


func open_input(label: StringName, type: Variant.Type) -> Port:
	var port := Port.new(label, type)
	_inputs.append(port)
	return port

func open_output(label: StringName, type: Variant.Type) -> Port:
	var port := Port.new(label, type)
	_outputs.append(port)
	return port





var _widget_inputs: Array[InternalConnection] = []
var _widget_outputs: Array[InternalConnection] = []


class InternalConnection:
	var _port: Port
	var _ui_address: UIAddress
	
	func _init(port: Port, ui_address: UIAddress) -> void:
		_port = port
		_ui_address = ui_address


class FinishSignal:
	var _object_reference: Node
	var _signal_name: StringName
	func _init(object_reference: Node, signal_name: StringName) -> void:
		_object_reference = object_reference
		_signal_name = signal_name

func create_ui_receiver(
	out_port_to_push_from: Port, 
	ui_object_reference: Node, 
	ui_property_name: StringName
) -> void:
	var address := UIReceiver.new(ui_object_reference, ui_property_name, &"Default label")
	_widget_inputs.append(InternalConnection.new(out_port_to_push_from, address))

func create_ui_emitter(
	ui_object_reference: Node, 
	change_signal: StringName
) -> void:
	ui_object_reference.connect(change_signal, Orchestrator.handle_ui_data)
	var address := UIEmitter.new(&"Default label")
	_widget_outputs
