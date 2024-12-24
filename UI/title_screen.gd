extends Control


func _on_start_pressed() -> void:
	LevelServer.change_scene(FileServer.ready_level_scene) #跳转到游戏准备场景
