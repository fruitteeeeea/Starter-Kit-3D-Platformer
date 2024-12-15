extends Control

@export var next_level : String

func _on_yes_pressed() -> void:
	LevelServer.change_scene(next_level)
	queue_free()

func _on_no_pressed() -> void:
	queue_free()
