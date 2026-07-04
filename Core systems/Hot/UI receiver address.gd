extends UIAddress
class_name UIReceiver

@export var _object_reference: Node
@export var _property_name: StringName
@export var _type: Variant.Type

func _init(object_reference: Node, property_name: StringName, label: StringName) -> void:
	_object_reference = object_reference
	_property_name = property_name
	_label = label
	_type = typeof(object_reference.get(property_name)) as Variant.Type
