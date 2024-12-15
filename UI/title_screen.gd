extends Control


func _on_start_pressed() -> void:
	LevelServer.change_scene("res://Unit/Level/ReadyLevel.tscn") #跳转到游戏准备场景
