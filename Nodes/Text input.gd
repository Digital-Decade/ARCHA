extends Nodule

static func widget() -> Array:
	var text_field := TextEdit.new()
	text_field.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var button := Button.new()
	button.text = "Send"
	
	return [text_field, button]

static func function(packet: Packet) -> Packet:
	var text: String = packet.get_input(0)
	packet.set_output(0, text)
	return packet
