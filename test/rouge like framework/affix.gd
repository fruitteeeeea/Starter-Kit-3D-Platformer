extends Control

@export var player : Control
@export var enemy : Control

#提升玩家的攻击伤害
func _on_button_pressed() -> void:
	player.do_modify_upgrade("attack_damage")

#提升玩家的攻击速度
func _on_button_2_pressed() -> void:
	player.do_modify_upgrade("attack_speed")
