extends Resource
class_name Address

enum Space {
	NODULES,
	WIDGETS
}

@export var nodule: int
@export var port_space: Space
@export var port: int
