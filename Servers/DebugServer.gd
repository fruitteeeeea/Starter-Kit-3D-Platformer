extends CanvasLayer

@export var DebugLabel : PackedScene
@onready var debug: VBoxContainer = $debug

func add_debuglabel():
	var label01 = DebugLabel.instantiate()
	debug.add_child(label01)
	return  label01
