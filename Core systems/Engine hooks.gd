extends RefCounted
class_name Hooks

func set_content_scale(
	host:Node,
	scalar:float = 1.0,
	) -> void:
	
	var window = host.get_window()
	window.content_scale_factor = scalar
