extends Nodule

static func setup(ports: Ports, _widget: Widget) -> void:
	ports.open_input(&"Normalized input", TYPE_FLOAT)
	ports.open_input(&"Exponent", TYPE_FLOAT)
	ports.open_input(&"Clipping point", TYPE_FLOAT)
	ports.open_output(&"Output", TYPE_FLOAT)

static func function(packet: Packet) -> void:
	var normalized_input: float = packet.read_input(0)
	var exponent: float = packet.read_input(1)
	var clipping_point: float = packet.read_input(2)
	var y_compensation = Preloader_temp_patch.exponent_flipped.manual_temp(clipping_point, exponent)
	var scaled_input = normalized_input * clipping_point
	var result: float = Preloader_temp_patch.exponent_flipped.manual_temp(scaled_input, exponent) * (1.0/y_compensation)
	packet.write_output(0, result)


static func manual_temp(normalized_input:float, exponent:float, clipping_point:float) -> float:
	var y_compensation = Preloader_temp_patch.exponent_flipped.manual_temp(clipping_point, exponent)
	var scaled_input = normalized_input * clipping_point
	return Preloader_temp_patch.exponent_flipped.manual_temp(scaled_input, exponent) * (1.0/y_compensation)
