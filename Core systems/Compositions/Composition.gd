class_name Composition 
extends Resource

@export var nodules: Array[Script]
@export var wires: Array[Wire]


func find_connected_ports(origin_address: PortAddress) -> Array[PortAddress]:
	var target_ports: Array = []
	for wire in wires:
		if wire.origin.equals(origin_address):
			target_ports.append(wire.target)
	return target_ports
