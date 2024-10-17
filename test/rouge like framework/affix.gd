extends Control

@export var player : Control
@export var enemy : Control

#通用属性修改函数
func do_attribute(attribute_name : String, modifier : float) -> void:
	if player.Attribute.has(attribute_name):
		player.Attribute[attribute_name] += player.Attribute[attribute_name] * modifier
		print(attribute_name + ":", player.Attribute[attribute_name])
	else:
		print("Attribute", attribute_name, "does not exist.")

#提升玩家的攻击伤害
func _on_button_pressed() -> void:
	player.Attribute["attack_damage"] += player.Attribute["attack_damage"] * .5
	print(player.Attribute["attack_damage"])

#提升玩家的攻击速度
func _on_button_2_pressed() -> void:
	do_attribute("attack_speed", - 0.5)
