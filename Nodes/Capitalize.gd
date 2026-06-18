extends Nodule

static func function(packet: Packet) -> Packet:
	var text: String = packet.get_input(0)
	packet.set_output(0, text.to_upper())
	return packet
