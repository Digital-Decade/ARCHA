extends Nodule

static func setup(ports: Ports, widget: Widget) -> void:
	var text_field = widget.add_text_field(6)
	var _button = widget.add_button("Send")
	ports.open_input(&"Text", TYPE_STRING)
	ports.open_output(&"Text", TYPE_STRING)
	
	ports.create_ui_emitter(0, text_field, &"text_changed")

static func function(packet: Packet) -> void:
	var text: String = packet.read_input(0)
	packet.write_output(0, text)
