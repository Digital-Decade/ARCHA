class_name NoduleAddress
extends Resource

@export var _composition: Composition
@export var _nodule_id: int
	
func _init(
	composition: Composition = null,
	nodule_id: int = 0
) -> void: 
	_composition = composition
	_nodule_id = nodule_id
	
func get_nodule_script() ->  Script:
	return _composition.nodules.get(_nodule_id)
	
