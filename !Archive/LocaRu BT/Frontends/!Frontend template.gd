extends Node
class_name UI

static var tab_name:String
var content_panel:Node
var parameters:Array = []
func _init(_tab_name:String, _parameters:Array[NamedControl], _content_panel) -> void:
	self.tab_name = _tab_name
	self.content_panel = _content_panel
	self.parameters = _parameters

enum ParamDisplayStyle {CONTROL_ONLY, TITLE_INLINE, TITLE_ABOVE}

class NamedControl:
	var control
	var name
	var display_style
	func _init(_control:Node, _name:String = "Unnamed parameter", _display_style:ParamDisplayStyle = ParamDisplayStyle.CONTROL_ONLY) -> void:
		self.control = _control
		self.name = _name
		self.display_style = _display_style
