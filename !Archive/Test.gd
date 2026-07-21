extends Node
class_name Test

static func run(host: Node):
	file_dialog_popup(host)
	
	
static func file_dialog_popup(host):
	var file_dialog = FileDialog.new()
	
	file_dialog.use_native_dialog = false
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	
	host.add_child(file_dialog)
	
	file_dialog.dir_selected.connect(directory_opener.bind(host))
	file_dialog.canceled.connect(func(): file_dialog.queue_free())
	file_dialog.dir_selected.connect(func(_path): file_dialog.queue_free())
	
	file_dialog.popup()
	
	
static func directory_opener(path, host):
	var directory = DirAccess.open(path)
	var file_paths: Array[String]
	for file_name in directory.get_files():
		file_paths.append(directory.get_current_dir().path_join(file_name))
	
	var ui_box = host.find_child("UI box")
	if ui_box and ui_box.get_child_count() > 0:
		# The ItemList is the first child of the UI box
		var item_list = ui_box.get_child(0) as GalleryItemList
		
		if item_list:
			item_list.populate_gallery(file_paths)
	else:
		push_error("Test script couldn't find the UI box or it was empty!")

	
	
	
