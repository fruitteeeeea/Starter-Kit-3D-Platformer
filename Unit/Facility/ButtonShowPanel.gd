extends Node

@export var UI : PackedScene
var is_enter := false

func do_stuff():
	is_enter = true
	Hud.massage.show_massage("按下E键以交互")

func unddo_stuff():
	is_enter = false
	Hud.massage.hide_massage()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && is_enter:
		show_panel()

func show_panel():
	if !UI or Hud.central_pos_panel.size() > 0: #确保当前只有这一个面板
		return
	
	Hud.add_central_pos_panel(UI)
