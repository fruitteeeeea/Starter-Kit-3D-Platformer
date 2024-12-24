extends Control

@onready var line_edit: LineEdit = $ColorRect/LineEdit

#
@export var debug_info := {
	
}

func _on_line_edit_text_submitted(new_text: String) -> void:
	print(line_edit.text)
	apply_debug_line()

#执行操作
func apply_debug_line():
	line_edit.text = ""
	pass
