class_name NodeWrapper

signal data_updated(new_value: Variant)

var uid: String
var type: String = "print output"

func _init(id: String) -> void:
	uid = id

func run(input_data: Variant) -> void:
	data_updated.emit(input_data)
