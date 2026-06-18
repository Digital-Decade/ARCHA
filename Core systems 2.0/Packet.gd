extends RefCounted
class_name Packet

var inputs: Dictionary = {}
var outputs: Dictionary = {}

func get_input(...port_ids: Array) -> Variant:
	if port_ids.size() == 0:
		return inputs.values()
	else:
		var selected_ports: Array = []
		for port_id in port_ids:
			if typeof(port_id) == TYPE_INT:
				selected_ports.append(inputs.values()[port_id])
			elif typeof(port_id) == TYPE_STRING_NAME:
				selected_ports.append(inputs[port_id])
		if selected_ports.size() == 1:
			return selected_ports[0]
		else:
			return selected_ports

func set_output(port_id: Variant, value: Variant) -> void:
	var selected_port
	if typeof(port_id) == TYPE_INT:
		selected_port = outputs.keys()[port_id]
	elif typeof(port_id) == TYPE_STRING_NAME:
		selected_port = outputs[port_id]
	outputs[selected_port] = value
