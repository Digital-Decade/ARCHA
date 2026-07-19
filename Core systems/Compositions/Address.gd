class_name Address 
extends Resource

@export var _nodule: int
@export var _port: int

func _init(
	nodule: int = 0,
	port: int = 0
) -> void:
	_nodule = nodule
	_port = port
