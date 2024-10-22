extends Control

@export var player : Control
@export var enemy : Control

#提升玩家的攻击伤害
func _on_button_pressed() -> void:
	player.do_status_modify("attack_damage")

#提升玩家的攻击速度
func _on_button_2_pressed() -> void:
	player.do_status_modify("attack_speed")


func _on_button_3_pressed() -> void:
	player.do_status_modify("crithit_rate")


func _on_button_4_pressed() -> void:
	player.do_status_modify("crithit_damage")
