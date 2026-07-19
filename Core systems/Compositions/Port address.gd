class_name PortAddress
extends Resource

@export var _nodule: int
@export var _port: int

func _init(
	nodule: int = 0,
	port: int = 0
) -> void:
	_nodule = nodule
	_port = port

func equals(port_address: PortAddress) -> bool:
	return _nodule == port_address._nodule and _port == port_address._port

func key() -> Vector2i:
	return Vector2i(_nodule, _port)
