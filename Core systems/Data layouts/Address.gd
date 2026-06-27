extends Resource
class_name Address

enum PortSpace {
	NODULES,
	WIDGETS
}

@export var nodule: int
@export var port_space: PortSpace
@export var port: int
