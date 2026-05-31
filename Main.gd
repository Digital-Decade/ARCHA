extends Node


func _printer(variable):
	print(variable)




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI.run(self)
	Test.run(self)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
