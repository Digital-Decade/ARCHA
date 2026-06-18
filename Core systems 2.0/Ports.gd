extends Node
class_name Ports

enum Direction { IN, OUT, SIDE }

var _inputs: Array[Port] = []
var _outputs: Array[Port] = []
var _widget_inputs: Dictionary = {}
var _widget_outputs: Dictionary = {}

func open_input(label: StringName, type: int) -> Port:
	var port := Port.new(label, type, Direction.IN)
	_inputs.append()

func open_output(label: StringName, type: int) -> Port:
	var port := Port.new()
	_outputs.append()

class Port:
	var _label: String
	var _type: int
	var _direction: Direction
	
	func _init(label: String, type: int, direction: Direction) -> void:
		_label = label
		_type = type
		_direction = direction
	
	func bind_with_ui_property():
		pass
