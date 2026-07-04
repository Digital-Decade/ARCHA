extends Nodule

static func interface(ports: Ports, _widget: Widget) -> void:
	ports.open_input(&"Text", TYPE_STRING)
	ports.open_output(&"Text", TYPE_STRING)

static func function(packet: Packet) -> void:
	var text: String = packet.get_input(0)
	text.to_upper()
	packet.set_output(0, text)
