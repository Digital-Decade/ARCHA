extends Resource
class_name Ports


var _inputs: Array[Port] = []
var _outputs: Array[Port] = []


class Port:
	var _label: StringName
	var _type: Variant.Type
	
	func _init(label: StringName, type: Variant.Type) -> void: 
		_label = label; _type = type

func open_input(label: StringName, type: Variant.Type) -> void:  # Add return Port again to give ore valid ways of configuration
	_inputs.append(Port.new(label, type))

func open_output(label: StringName, type: Variant.Type) -> void:
	_outputs.append(Port.new(label, type))




var _ui_receiver_wires: Array[InternalWire] = []
var _ui_emitters_wires: Array[InternalWire] = []


class InternalWire:
	var _port_id: int
	var _ui_address: UIAddress
	
	func _init(port_id: int, ui_address: UIAddress) -> void: _port_id = port_id; _ui_address = ui_address

class UIAddress:
	var _label: String
	
	func _init(label: String) -> void:
		_label = label

class UIReceiver extends UIAddress:
	var _object_reference: Node
	var _property_name: StringName
	var _type: Variant.Type

	func _init(
		object_reference: Node,
		property_name: StringName,
	) -> void:
		_object_reference = object_reference
		_property_name = property_name
		_type = typeof(object_reference.get(property_name)) as Variant.Type

class UIEmitter extends UIAddress:
	var _object_reference: Node
	var _signal_name: StringName
	
	func _init(
		object_reference: Node, 
		signal_name: StringName
	) -> void: 
		_object_reference = object_reference
		_signal_name = signal_name




func create_ui_receiver(
	out_port_to_push_from: int, 
	ui_object_reference: Node, 
	ui_property_name: StringName
) -> void:
	var address := UIReceiver.new(ui_object_reference, ui_property_name)
	_ui_receiver_wires.append(InternalWire.new(out_port_to_push_from, address))

func create_ui_emitter(
	ingest_port: int,
	ui_object_reference: Node, 
	change_signal: StringName
) -> void:
	Orchestrator.signal_connector(ingest_port, ui_object_reference, change_signal)
	var address := UIEmitter.new(ui_object_reference, change_signal)
	_ui_emitters_wires.append(InternalWire.new(ingest_port, address))
