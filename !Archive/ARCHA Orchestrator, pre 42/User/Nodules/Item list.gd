extends Nodule

static func setup(ports: Ports, _widget: Widget) -> void:
	
	var item_list = ItemList.new()
	item_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	item_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_list.max_columns = 1000
	item_list.icon_mode = ItemList.ICON_MODE_TOP
	
	item_list.add_item("aaaa")
	item_list.add_item("bbbb")
	
	_widget.append_custom_controls(item_list)
	
	ports.open_input(&"Activated item index", TYPE_INT)
#	ports.open_input(&"Clicked item index", TYPE_INT)
	ports.open_output(&"out1", TYPE_STRING)
#	ports.open_output(&"out2", TYPE_STRING)
#	ports.create_ui_emitter(0, item_list, &"item_activated", 0) # Target function : open_double_clicked_file
	ports.create_ui_emitter(0, item_list, &"item_clicked", 0) # Target function : item_click_handler

static func function(packet: Packet) -> void:
	var text: String = str(packet.read_input(0))
	packet.write_output(0, text)
