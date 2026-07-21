extends Node
class_name  JSON_IO


static func read_json(json_file_path:String) -> Variant: # Could return any type that the json file ends up containing.
	var json_file = FileAccess.open(json_file_path, FileAccess.READ)
	var json_string = json_file.get_as_text()
	json_file.close()
	var json = JSON.new()
	json.parse(json_string)
	return json.data
	
static func write_json(json_file_path:String, variable_to_be_written) -> void:
	if FileAccess.file_exists(json_file_path) == false:
		var json_file_directory = json_file_path.get_base_dir()
		if not DirAccess.dir_exists_absolute(json_file_directory):
			DirAccess.make_dir_recursive_absolute(json_file_directory)
	var json_file = FileAccess.open(json_file_path, FileAccess.WRITE)
	json_file.store_string(JSON.stringify(variable_to_be_written, " ", false))
