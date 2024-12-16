extends Control

func _on_yes_pressed() -> void:
	LevelServer.change_level()
	queue_free()

func _on_no_pressed() -> void:
	queue_free()
