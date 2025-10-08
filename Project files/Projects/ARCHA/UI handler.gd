### TODO

# Make it so the OS.fileopen doesn't use the text box contents but instead pulls from a loaded path stored in memory. That way even if the text in the box is premptively changed you can still open files in the grid.

# Make a page changer that auto switches to the next page on click.


#########################
extends Node



@onready var frontends:Array[Node] = get_node("Shown frontends").get_children() # Probably best to select which UIs to show via the code

@onready var tab_bar:Node = get_node("UI Root/VBox/Top bar/VBox/HBox/Tabs")
@onready var content_panel:Node = get_node("UI Root/VBox/Main section/Content panel/Scroll/Margin")
@onready var parameters_panel:Node = get_node("UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox")
@onready var status_bar:Node = get_node("UI Root/VBox/Status bar/HBoxContainer/MarginContainer/RichTextLabel")

#@onready var loaded_resources = [load("res://Project_files/Projects/ARCHA/Access/Load image.gd")]



func _ready() -> void: 
	draw_tabs(frontends)

	
	



func _on_tab_clicked(tab: int) -> void: 
	draw_panels(tab)
	# Maybe connect signals at some point



func draw_tabs(tabs_to_draw) -> void:
	tab_bar.clear_tabs()
	for tab_to_draw in tabs_to_draw:
		tab_bar.add_tab(tab_to_draw.tab_name)

func draw_panels(tab_index) -> void: # Perhaps this should only append a ready made child node, composed by a templater.
	
	for child in parameters_panel.get_children():
		parameters_panel.remove_child(child)
	
	content_panel.add_child(
		frontends[tab_index].content_panel
	)
	
	for parameter in frontends[tab_index].parameters:
		
		# Configs for all display styles
		var parameter_with_name
		
		var label = RichTextLabel.new()
		label.text = parameter.name + ":"
		label.fit_content = true
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.scroll_active = false
		label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		
		parameter.control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		parameter.control.size_flags_vertical = Control.SIZE_FILL
		
		# Configs specific to a display style
		match parameter.display_style:
			
			UI.ParamDisplayStyle.CONTROL_ONLY:
				parameter_with_name = BoxContainer.new()
				label.visible = false
			
			UI.ParamDisplayStyle.TITLE_INLINE:
				parameter_with_name = HBoxContainer.new()
			
			UI.ParamDisplayStyle.TITLE_ABOVE: 
				parameter_with_name = VBoxContainer.new()
				parameter.control.custom_minimum_size.y = 100.0

		parameter_with_name.add_child(label)
		parameter_with_name.add_child(parameter.control)
		
		parameters_panel.add_child(parameter_with_name)

#func connect_signals(tab_index):
	#pass

#func draw_status_bar(text_to_display) -> void:
	#status_bar.text = text_to_display




	#information.emit(file_counter, items_per_page, page, item_size)
