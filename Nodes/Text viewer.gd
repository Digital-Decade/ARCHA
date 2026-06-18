extends Nodule

static func widget() -> Array:
	var text_label := RichTextLabel.new()
	text_label.text = "test"
	text_label.fit_content = true
	
	return [text_label]

static func function(packet: Packet) -> Packet:
	var text: String = packet.get_input(0)
	print("--- Prototype success ---")
	print(text)
	packet.set_output(0, text)
	return packet
	
