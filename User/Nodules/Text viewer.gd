extends Nodule

static func interface(ports: Ports, widget: Widget) -> void:
	var text_label: RichTextLabel = widget.add_text_label("Test")
	
	ports.open_input(&"Text", TYPE_STRING)
	var output := ports.open_output(&"Text", TYPE_STRING)
	ports.create_ui_receiver(output, text_label, &"text")


static func function(packet: Packet) -> void:
	var text: String = packet.read_input(0)
	packet.write_output(0, text)
	
