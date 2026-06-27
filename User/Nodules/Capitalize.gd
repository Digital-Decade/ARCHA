extends Nodule

static func function(packet: Packet) -> void:
	var text: String = packet.get_input(0)
	text.to_upper()
	packet.set_output(0, text)
