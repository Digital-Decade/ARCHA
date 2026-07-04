extends Resource
class_name NoduleAddresses

@export var _nodule_id: int
@export var _ports: Ports

func _init(nodule_id: int, ports: Ports) -> void:
	_nodule_id = nodule_id
	_ports = ports
