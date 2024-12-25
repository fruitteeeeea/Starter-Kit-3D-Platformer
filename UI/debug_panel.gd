extends Control

@onready var line_edit: LineEdit = $ColorRect/LineEdit

#
@export var debug_info := {
	

}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug2"):
		visible =! visible
		line_edit.grab_focus()
		line_edit.select_all()

func _on_line_edit_text_submitted(new_text: String) -> void:
	match new_text:
		"add loot":
			LootServer.update_loot_status(1)
			print("添加 1 个战利品")
		"add 10xloot":
			LootServer.update_loot_status(9, 3)
			print("添加 1 0 个战利品")
		
		_:
			print("未找到匹配方法")
			
	apply_debug_line()

#执行操作
func apply_debug_line():
	line_edit.text = ""
	pass
