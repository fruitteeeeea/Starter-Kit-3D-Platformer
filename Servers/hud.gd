extends CanvasLayer

@onready var debug: VBoxContainer = $Debug
@export var DebugLabel : PackedScene

func add_debuglabel():
	var label01 = DebugLabel.instantiate()
	debug.add_child(label01)
	return  label01
	pass
