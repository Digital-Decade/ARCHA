extends Nodule

static func setup(ports: Ports, _widget: Widget) -> void:
	ports.open_input(&"input", TYPE_FLOAT)
	ports.open_output(&"output", TYPE_FLOAT)

static func function(packet: Packet) -> void:
	var input:float = packet.read_input(0)
	var result: float = 1/(1+exp(input))
	packet.write_output(0, result)
	
	
static func manual_temp(input:float) -> float:
	return 1/(1+exp(input))
