extends RefCounted
class_name Ports

enum Direction { IN, OUT, SIDE }

var _inputs: Array[Port] = []
var _outputs: Array[Port] = []

func open_input(label: StringName, type: int) -> Port:
	var port := Port.new(label, type, Direction.IN)
	_inputs.append(port)
	return port

func open_output(label: StringName, type: int) -> Port:
	var port := Port.new(label, type, Direction.OUT)
	_outputs.append(port)
	return port

class Port:
	var _label: String
	var _type: int
	var _direction: Direction
	
	func _init(label: String, type: int, direction: Direction) -> void:
		_label = label
		_type = type
		_direction = direction
	
	func bind_with_ui_property(ui_port: UIPropertyAddress):
		var types_match: bool = (_type == ui_port._type)
		var port_directions_match: bool = (
			(_direction == Direction.OUT && ui_port._direction == Direction.IN) 
			||
			(_direction == Direction.IN && ui_port._direction == Direction.OUT)
		)
		
		if types_match && port_directions_match:
			pass

class UIPropertyAddress:
	var _object_reference: Node
	var _property_name: StringName
	var _label: String
	var _type: int
	var _direction: Direction
	
	func _init(object_reference: Node, property_name: StringName, label: String, direction: Direction) -> void:
		_object_reference = object_reference
		_property_name = property_name
		_label = label
		_type = typeof(object_reference.get(property_name))
		_direction = direction
	
	
