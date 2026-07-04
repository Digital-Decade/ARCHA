extends Resource
class_name Connection

@export var _source_address: Address
@export var _target_address: Address

func _init(source_address: Address, target_address: Address) -> void:
	_source_address = source_address
	_target_address = target_address
