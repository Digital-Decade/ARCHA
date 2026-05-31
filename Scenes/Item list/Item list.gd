extends ItemList
class_name GalleryItemList


func _ready() -> void:
	item_activated.connect(_on_item_activated)


func populate_gallery(file_paths: Array[String]):
	clear()
	
	for file_path in file_paths:
		var img = Image.load_from_file(file_path)
		var texture: ImageTexture
		if img and not img.is_empty():
			texture = ImageTexture.create_from_image(img)
		else:
			img = Image.load_from_file("res://icon.svg")
			texture = ImageTexture.create_from_image(img)
		var index = add_item(file_path.get_file(), texture)
		set_item_metadata(index, file_path)
		
		
func _on_item_activated(index: int):
	# Pull the hidden file path out using the clicked index row
	var raw_path = get_item_metadata(index)
	
	if raw_path:
		# Convert Godot virtual paths (like user://) into hard system paths
		var absolute_path = ProjectSettings.globalize_path(raw_path)
		
		# Agnostic OS Handling: Android strictly demands the 'file://' URI schema 
		if OS.get_name() == "Android":
			absolute_path = "file://" + absolute_path
			
		print("Requesting OS to open file: ", absolute_path)
		
		# Hand control over to the OS default application handler
		var error = OS.shell_open(absolute_path)
		
		if error != OK:
			push_error("OS failed to open the file. Error code: ", error)
