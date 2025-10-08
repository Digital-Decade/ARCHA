extends Node
class_name Cache

var image_loading_thread = Thread.new()



signal ThumbnailLoaded(global_index, thumbnail)
func dummy(): pass
func _ready() -> void: ThumbnailLoaded.connect(dummy)
	



var img = ImageTools.new()

var cached_directory_path:String = ""
var cached_items:Array[PreloadedFile] = []
var cached_items_count:int = 0
var currently_displayed:Array[int]
var fallback_texture = img.fallback_texture
func _init(folder_path) -> void:
	cached_items.clear()
	cached_directory_path = folder_path
	var dir = DirAccess.open(folder_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var file_counter = 0
	while file_name != "":
		cached_items.append(PreloadedFile.new(file_name))
		file_counter += 1
		file_name = dir.get_next()
	cached_items_count = file_counter
	dir.list_dir_end()

class PreloadedFile:
	var file_name:String
	var thumbnail:Texture2D # ~~Can be ImageTexture or AnimatedTexture so eh, don't think you can have a double type~~
	func _init(
		_file_name:String, 
		_thumbnail = null, 
	) -> void:
		self.file_name = _file_name
		self.thumbnail = _thumbnail






var thread = MultiThreading.new()


func launch_async_thumbnail_fetch(indices):
	currently_displayed = indices
	thread.launch(query_cache_threaded, true, [])

func query_cache_threaded(breaker:Breaker) -> void:
	for global_index in currently_displayed:
		if breaker.check_for_break_request(): break
		var thumbnail
		match cached_items[global_index].thumbnail:
			null: 
				thumbnail = ImageTools.decode_image(cached_directory_path + cached_items[global_index].file_name)
				cached_items[global_index].thumbnail = thumbnail
			_:
				thumbnail = cached_items[global_index].thumbnail
		call_deferred("emit_signal", "ThumbnailLoaded", global_index, thumbnail)



# Generate the reordered list of files first, and have all parts of the program respect that order and go through it in their logic
