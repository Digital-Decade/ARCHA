extends Resource
class_name Ports

var _inputs: Array[Port] = []
var _outputs: Array[Port] = []


class Port:
	var _label: StringName
	var _type: Variant.Type
	
	func _init(label: StringName, type: Variant.Type) -> void: _label = label; _type = type

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
	var _object_reference: Node
	var _type: Variant.Type
	
	func _init(label: String, object_reference: Node, type: Variant.Type) -> void: _label = label; _object_reference = object_reference; _type = type

class UIReceiver extends UIAddress:
	var _property_name: StringName

	func _init(object_reference: Node, property_name: StringName) -> void:
		_object_reference = object_reference
		_property_name = property_name
		_type = typeof(object_reference.get(property_name)) as Variant.Type

class UIEmitter extends UIAddress:
	# Needs a whole additional system to enable sourcing data from object property rather than signal argument
	var _signal_name: StringName
	var _data_source: Variant
	
	func _init(object_reference: Node, signal_name: StringName, data_source: Variant) -> void: 
		_object_reference = object_reference
		_signal_name = signal_name
		match typeof(data_source):
			TYPE_INT:
				_data_source = data_source
				var signal_info := GDTools.find_signal_info(object_reference, signal_name)
				if not signal_info.is_empty():
					var arguments: Array = signal_info["args"]
					if arguments.size() > 1:
						_type = arguments[data_source]["type"] as Variant.Type
					else:
						_type = TYPE_NIL
			TYPE_STRING_NAME:
				_data_source = data_source
				_type = typeof(object_reference.get(data_source)) as Variant.Type
			_:
				push_error("Data source argument should either be of TYPE_INT to indicate a signal argument position, or of TYPE_STRING_NAME to indicate an object property.")
				

func create_ui_receiver(
	out_port_to_push_from: int, 
	ui_object_reference: Node, 
	ui_property_name: StringName
) -> void:
	var address := UIReceiver.new(ui_object_reference, ui_property_name)
	if address._type != _outputs.get(out_port_to_push_from)._type:
		push_error("UI receiver type (%s) doesn't match port type (%s)." % [typeof(address._type), typeof(_outputs.get(out_port_to_push_from)._type)])
		return
	_ui_receiver_wires.append(InternalWire.new(out_port_to_push_from, address))

func create_ui_emitter(
	ingest_port: int,
	ui_object_reference: Node, 
	change_signal: StringName,
	data_source: Variant
) -> void:
	var address := UIEmitter.new(ui_object_reference, change_signal, data_source)
	if address._type != _inputs.get(ingest_port)._type:
		push_error("UI emitter type (%s) doesn't match port type (%s)." % [type_string(address._type), type_string(_inputs.get(ingest_port)._type)])
		return
	_ui_emitters_wires.append(InternalWire.new(ingest_port, address))
