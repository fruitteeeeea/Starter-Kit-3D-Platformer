extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Hud.current_LootUI = self #注册自己为当前场景的暂停UI


func _on_close_pressed() -> void:
	hide()
