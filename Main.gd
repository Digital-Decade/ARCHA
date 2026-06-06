extends Node

func _ready() -> void:
	#UI.run(self)
	
	ConsolePrinter.run(Upper.run("Hello world!"))
