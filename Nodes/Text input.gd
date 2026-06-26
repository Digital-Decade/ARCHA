extends Nodule

static func interface(ports: Ports, widget: Widget) -> void:
	var text_field := TextEdit.new()
	text_field.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var button := Button.new()
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.text = "Send"
	
	widget.create()
	widget.append_custom_controls(text_field, 6)
	widget.append_custom_controls(button)
	
	ports.open_input(&"Text", TYPE_STRING)
	ports.open_output(&"Text", TYPE_STRING)
	
	ports.FinishSignal.new(text_field, &"text_changed")
	ports.FinishSignal.new(button, &"pressed")
	
	ports.create_ui_emitter(text_field, &"text_changed")
	
	return

static func function(packet: Packet) -> void:
	var text: String = packet.get_input(0)
	packet.set_output(0, text)
