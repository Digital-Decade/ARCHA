extends Resource
class_name Packet

@export var _inputs: Dictionary = {}
@export var _outputs: Dictionary = {}

func read_input(...port_ids: Array) -> Variant:
	if port_ids.size() == 0:
		return _inputs.values()
	else:
		var selected_ports: Array = []
		for port_id in port_ids:
			if typeof(port_id) == TYPE_INT:
				selected_ports.append(_inputs.values().get(port_id))
			elif typeof(port_id) == TYPE_STRING_NAME:
				selected_ports.append(_inputs.get(port_id))
		if selected_ports.size() == 1:
			return selected_ports[0]
		else:
			return selected_ports

func write_output(port_id: Variant, value: Variant) -> void:
	if typeof(port_id) == TYPE_INT:
		var key: StringName = _outputs.keys()[port_id]
		_outputs.set(key, value)
	elif typeof(port_id) == TYPE_STRING_NAME:
		_outputs.set(port_id, value)
