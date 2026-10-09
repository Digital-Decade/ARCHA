extends Node

func load_standard_ui() -> void:
	pass

func load__scene() -> void:
	var locaru_scene: PackedScene = load("res://Dev/LocaRu/LocaRu (temp view, simplified ARCHAlite).tscn")
	var locaru_instance: Node = locaru_scene.instantiate()
	add_child(locaru_instance)

func _ready() -> void:
	load_alternate_scene()
