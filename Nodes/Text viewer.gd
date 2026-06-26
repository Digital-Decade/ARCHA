extends Nodule

static func interface(ports: Ports, widget: Widget) -> void:
	widget.create()
	var text_label := RichTextLabel.new()
	text_label.text = "test"
	text_label.fit_content = true
	text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	widget.append_custom_controls(text_label)
	
	ports.open_input(&"Text", TYPE_STRING)
	var output := ports.open_output(&"Text", TYPE_STRING)
	widget.set_ui_receiver(output, text_label, &"text")
	
	return

static func function(packet: Packet) -> void:
	var text: String = packet.get_input(0)
	packet.set_output(0, text)
	
