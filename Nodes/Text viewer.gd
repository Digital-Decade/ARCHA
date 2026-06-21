extends Nodule

static func interface(ports: Ports, widget: Widget) -> void:
	var text_label := RichTextLabel.new()
	text_label.text = "test"
	text_label.fit_content = true
	text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	ports.open_input(&"Text", TYPE_STRING)
	ports.open_output(&"Text", TYPE_STRING)
	widget.create()
	widget.append_custom_controls(text_label)
	
	return

static func function(packet: Packet) -> void:
	var text: String = packet.get_input(0)
	packet.set_output(0, text)
	
