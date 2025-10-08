extends Node
class_name ImageTools


static var fallback_texture = load("res://Project_files/icon.svg")

static func decode_image(file_path = "") -> Texture2D: # ~~Return type could be ImageTexture or AnimatedTexture for gifs, double type returns don't exist afaik~~
	var texture
	match file_path.get_extension().to_lower():
		"png", "jpg", "jpeg", "bmp", "webp":
			var image = Image.new()
			var error = image.load(file_path)
			if error != OK or image.is_empty():
				texture = fallback_texture
			else:
				texture = ImageTexture.create_from_image(image)
		"jfif": # Grok solution to read .jfif as .jpg. If .jfif is really different from .jpg for that file and creates an error, just use fallback Godot SVG as usual.
			var file = FileAccess.open(file_path, FileAccess.READ)
			var buffer = file.get_buffer(file.get_length())
			file.close()

			var image = Image.new()
			var error = image.load_jpg_from_buffer(buffer)
			if error != OK:
				print("Error loading JFIF as JPEG: ", error)
				texture = fallback_texture
			else: texture = ImageTexture.create_from_image(image)
		"gif":
			return GifManager.animated_texture_from_file(file_path)
			#texture = fallback_texture
		_:
			texture = fallback_texture
	return texture
