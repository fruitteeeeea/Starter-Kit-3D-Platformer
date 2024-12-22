extends Control

var is_display := false #是否处于显示中

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_option"):
		is_display =! is_display
		change_display_state()

func change_display_state():
	match is_display:
		true:
			show()
			get_tree().paused = true
		false:
			hide()
			get_tree().paused = false

func _on_continue_pressed() -> void:
	is_display =! is_display
	change_display_state()
