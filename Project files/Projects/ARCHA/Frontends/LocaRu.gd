

### ----------------------------------------------
### UI SHIZ BELOW

extends UI
class_name LocaRu
func _init() -> void:
	super._init("LocaRu", locaru_parameters(), locaru_content_panel())
func locaru_content_panel() -> Node:
	var content = ItemList.new()
	content.connect("item_activated", open_double_clicked_file)
	content.connect("item_clicked", item_click_handler)
	content.allow_rmb_select = true
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.max_columns = 1000
	content.icon_mode = ItemList.ICON_MODE_TOP
	return content
func locaru_parameters() -> Array[NamedControl]:
	
	var params:Array[NamedControl] = []
	
	var control
	
	control = TextEdit.new()
	control.text = "Insert your folder path"
	control.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	control.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	params.append(NamedControl.new(control, "File path", ParamDisplayStyle.TITLE_ABOVE))
	
	control = Button.new()
	control.text = "Load directory"
	control.connect("pressed", _request_directory_load)
	params.append(NamedControl.new(control))
	
	control = SpinBox.new()
	control.min_value = 1
	control.max_value = 9999
	control.value = 100
	params.append(NamedControl.new(control, "Items per page", ParamDisplayStyle.TITLE_INLINE))
	
	control = SpinBox.new()
	control.min_value = 1
	control.max_value = 9999
	control.value = 1
	params.append(NamedControl.new(control, "Page number", ParamDisplayStyle.TITLE_INLINE))
	
	control = HSlider.new()
	control.min_value = 0
	control.max_value = 1
	control.step = 0.001
	control.value = 0.5
	control.connect("value_changed", resize_list_icons)
	params.append(NamedControl.new(control, "Item size", ParamDisplayStyle.TITLE_INLINE))
	
	control = OptionButton.new()
	control.add_item("Normal")
	control.add_item("Bradley-Terry")
	control.add_item("Negative Bradley-Terry")
	control.select(2)
	params.append(NamedControl.new(control, "Sorting algorithm", ParamDisplayStyle.TITLE_INLINE))
	
	control = LineEdit.new()
	control.text = ".LocaRu\\Relational comparisons.json"
	params.append(NamedControl.new(control, "Sorting data", ParamDisplayStyle.TITLE_INLINE))
	
	control = SpinBox.new()
	control.min_value = 1
	control.max_value = 10000
	control.value = 10
	control.tooltip_text = "20 is generally the max iterations you need. Depending on the size of the dataset, you should lower that down to a minimum of 5."
	params.append(NamedControl.new(control, "Iterations", ParamDisplayStyle.TITLE_INLINE))
	
	control = Button.new()
	control.text = "Display selected page"
	control.connect("pressed", _request_page_load)
	params.append(NamedControl.new(control))
	
	control = null
	
	return params

var locaru_grid
var selected_path:String
var items_per_page:int
var page_number:int
var item_display_size:float
var ranking_algorithm
var sorting_data_path:String
var max_iterations:int
var archa_status_bar_hack:Node
func rescan_param_values(): 
	locaru_grid = get_node("../../UI Root/VBox/Main section/Content panel/Scroll/Margin/").get_child(0)
	selected_path = get_node("../../UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox/").get_child(0).get_child(1).text
	items_per_page = get_node("../../UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox/").get_child(2).get_child(1).value
	page_number = get_node("../../UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox/").get_child(3).get_child(1).value
	item_display_size = get_node("../../UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox").get_child(4).get_child(1).value
	ranking_algorithm = get_node("../../UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox").get_child(5).get_child(1).get_selected_id()
	sorting_data_path = get_node("../../UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox").get_child(6).get_child(1).text
	max_iterations = get_node("../../UI Root/VBox/Main section/Side panel/Scroll/Margin/VBox").get_child(7).get_child(1).value
	archa_status_bar_hack = get_node("../../UI Root/VBox/Status bar/HBoxContainer/MarginContainer/RichTextLabel")
	print("The currently selected parameters have been queried by the software")


### UI SHIZ ABOVE
### ------------------------------------------------------


var locaru_cache:Cache
var comparisons_array:Array = []
var temp_index_winner:String
var temp_index_loser:String
var global_indices_on_this_page:Array[int]
var ranking_iterations_running:bool = false

var rank = Ranking.new()
var threads = HyperThreading.new()


var page_slicing:HyperThreading = HyperThreading.new()
func page_slicing_thread_launcher(ranked_files:Array[Ranking.ScoredItem], iteration_number) -> void:
	page_slicing.launch(slice_page_from_ranking, true, [ranked_files, iteration_number])

signal PageResultsSliced(slice)
signal StatusBarMessage(message) # Maybe at some point when I'll implement connecting signals through the UI handler instead of manipulating it from the UI scripts
#func dummy(): pass
func _ready() -> void:
	rank.RankingIterated.connect(page_slicing_thread_launcher)
	PageResultsSliced.connect(redraw_item_list)
	StatusBarMessage.connect(hack_archa_status_bar_text)
	rank.AllProcessingComplete.connect(_on_last_sort_complete)


### Events

func _request_directory_load() -> void:
	rescan_param_values() # Good enough for now, maybe split later idk
	locaru_cache = Cache.new(selected_path)
	locaru_cache.ThumbnailLoaded.connect(update_item_icon)

func _request_page_load() -> void:
	if locaru_cache == null: # That feels like a cheap way to catch errors
		push_warning("You have to load a directory first!")
	else:
		rescan_param_values()
		var sorting_data_file_path = locaru_cache.cached_directory_path + sorting_data_path
		if FileAccess.file_exists(sorting_data_file_path) == true:
			comparisons_array = JSON_IO.read_json(sorting_data_file_path) # Add versioning to the comparisons array read from the file
		regenerate_global_index(ranking_algorithm, comparisons_array) 

func open_double_clicked_file(page_index) -> void:
	var full_path = locaru_cache.cached_directory_path + locaru_cache.cached_items[global_indices_on_this_page[page_index]].file_name # If making a query all the time is too slow, pregenerate an array[int] with the global index that you can query.
	OS.shell_open(full_path)

func item_click_handler(index, _at_pos, mouse_button) -> void: # Left click to select LOSER, right click to select WINNERS. Auto writes to file.
	match mouse_button:
		MouseButton.MOUSE_BUTTON_LEFT:
			temp_index_winner = locaru_cache.cached_items[global_indices_on_this_page[index]].file_name
		MouseButton.MOUSE_BUTTON_RIGHT:
			temp_index_loser = locaru_cache.cached_items[global_indices_on_this_page[index]].file_name
			if temp_index_winner != null:
				comparisons_array.append([temp_index_winner, temp_index_loser])
				print([temp_index_winner, temp_index_loser])
				JSON_IO.write_json(locaru_cache.cached_directory_path + sorting_data_path, comparisons_array)
		MouseButton.MOUSE_BUTTON_MIDDLE:
			DisplayServer.clipboard_set("\"" + locaru_cache.cached_items[global_indices_on_this_page[index]].file_name + "\"")

func _on_last_sort_complete() -> void:
	ranking_iterations_running = false
	await get_tree().create_timer(0.2).timeout # Real shitty hacky method cuz I have no clue rn it's 2am bro, prevents this thread from completing too fast and then the thread with a new sorting iteration overrides the status bar message.
	hack_archa_status_bar_text(archa_status_bar_hack.text + " - done")


### Functions

func redraw_item_list(list_to_update:ItemList, item_names:Array[String] = []) -> void: # Hardcoded to generate list without thumbnails, for thumbnails, edit ItemList object after the fact.
	list_to_update.clear()
	resize_list_icons(item_display_size, locaru_grid)
	for item_name in item_names:
		list_to_update.add_item(item_name, locaru_cache.fallback_texture)
	locaru_cache.launch_async_thumbnail_fetch(global_indices_on_this_page)

func resize_list_icons(scale, list_to_update:Node = locaru_grid) -> void:
	item_display_size = scale
	var scaled_size:float = 100.0 + 900.0 * Curves.exponent_flipped_clipped(scale, 10.0, 0.995) # Replace with e exponent function probably.
	#scaled_size = 100 + 900*scale # Linear scale method for comparison (shit)
	list_to_update.fixed_column_width = scaled_size
	list_to_update.fixed_icon_size = Vector2i(int(scaled_size), int(scaled_size))

func update_item_icon(global_index:int, thumbnail:Texture2D) -> void: # Yay, found out you can use Texture2D to encompass AnimatedTexture and ImageTexture. Less broad than a Variant, so it's cool.
	if global_indices_on_this_page.find(global_index) != -1:
		var local_page_index:int = global_indices_on_this_page.find(global_index)
		locaru_grid.set_item_icon(local_page_index, thumbnail)

func regenerate_global_index(_ranking_algorithm, data_to_sort_against) -> void:
	var files_names:Array[String] = []
	for item in locaru_cache.cached_items:
		files_names.append(item.file_name) # Will this be sturdy enough ? >> I believe so but when I switch to IDs it's gonna be a fun game of cat and mouse replacing all the logic that used file names.
	
	ranking_iterations_running = true # ??
	match _ranking_algorithm:
		0: threads.launch(rank.no_ranking_passthrough, false, [files_names])
		1: threads.launch(rank.bradley_terry, true, [data_to_sort_against, files_names, max_iterations, 1.0]) # Since this is gonna do it's thing then send back a signal, I need to catch the signal and send it directly to something that will continue the job.
		2: threads.launch(rank.negative_bradley_terry, true, [data_to_sort_against, files_names, max_iterations])

func slice_page_from_ranking(breaker:Breaker, ranked_files:Array[Ranking.ScoredItem], iteration_number) -> void:
	var status_bar_text = "Current iteration: " + str(iteration_number+1 if iteration_number != -1 else max_iterations) + "/" + str(max_iterations)
	call_deferred("emit_signal", "StatusBarMessage", status_bar_text)
	while breaker.check_for_break_request() == false:
		var new_array:Array[int]
		for i in range(items_per_page*(page_number-1), items_per_page*page_number, 1):
			if i < locaru_cache.cached_items_count:
				new_array.append(ranked_files[i].original_order)
		global_indices_on_this_page = new_array
		
		var sorted_files:Array[String]
		for i in global_indices_on_this_page:
			sorted_files.append(locaru_cache.cached_items[i].file_name)
		call_deferred("emit_signal", "PageResultsSliced", locaru_grid, sorted_files)
		breaker.request_break()



func hack_archa_status_bar_text(text) -> void: # To be replaced once I implement proper runtime signal connections via the UI handler, so it is the one to receive and update the status bar messages itself.
	archa_status_bar_hack.text = text



###################################################################

#
#wraptype
#wrapper
#transforms that return wrapped
#run function that pre unwraps and also handles the side stuff
