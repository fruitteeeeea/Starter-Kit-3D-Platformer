extends Control


func _on_yes_pressed() -> void:
	LevelServer.change_to_shop_level() #前往下一个关卡
	queue_free()


func _on_no_pressed() -> void:
	queue_free()
