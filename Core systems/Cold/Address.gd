extends Resource
class_name Address

@export var _nodule: int
@export var _port: int

func _init(nodule: int, port: int) -> void:
	_nodule = nodule
	_port = port
