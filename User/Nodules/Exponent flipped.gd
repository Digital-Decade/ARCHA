extends Nodule

static func setup(ports: Ports, _widget: Widget) -> void:
	ports.open_input(&"Normalized input", TYPE_FLOAT)
	ports.open_input(&"Exponent", TYPE_FLOAT)
	ports.open_output(&"Output", TYPE_FLOAT)

static func function(packet: Packet) -> void:
	var normalized_input: float = packet.read_input(0)
	var exponent: float = packet.read_input(1)
	var result: float = 1.0-pow((1.0-normalized_input), 1.0/exponent)
	packet.write_output(0, result)

static func manual_temp(normalized_input:float, exponent:float) -> float:
	return 1.0-pow((1.0-normalized_input), 1.0/exponent)
