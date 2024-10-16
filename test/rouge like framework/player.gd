extends Control

#白字属性
var attack_damage := 10.0 #白字攻击伤害
var attack_speed := 1.2
var crithit_rate := 0.2

##首先 应当具备读取和修改里面的值
@export var Attribute := {
	"attack_speed" : 1.0, 
	"attack_damage" : 1.0, #攻击伤害加成
	"crithit_rate" : 1.0,
	"crithit_damage" : 1.0,
	"move_speed" : 1.0,
	"jump_hight" : 1.0
}

#临时属性
@export var tempo_modify := {
	"attack_speed" : 1.0, 
	"attack_damage" : 1.0, #攻击伤害加成
	"crithit_rate" : 1.0,
	"crithit_damage" : 1.0,
	"move_speed" : 1.0,
	"jump_hight" : 1.0
}

func deal_damage(): #造成伤害
	var final_damage = attack_damage * Attribute["attack_damage"] #现场计算伤害结果
	print(final_damage)


func take_damage(): #接受伤害
	pass


func _on_button_pressed() -> void:
	deal_damage()
