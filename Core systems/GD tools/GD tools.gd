extends Node
class_name GDTools


static func find_signal_info(object_reference: Node, signal_name: StringName) -> Dictionary:
	for sig in object_reference.get_signal_list():
		if sig["name"] == signal_name:
			return sig
	return {}
