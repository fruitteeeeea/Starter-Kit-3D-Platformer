extends Control

@export var Enemy : Control #指定敌人节点
@onready var button: Button = $Button #攻击按钮

#白字属性
var attack_damage := 10.0 #白字攻击伤害
var attack_speed := 1.2

#展示标签
@onready var attack_damage_label: Label = $VBoxContainer/HBoxContainer/AttackDamageLabel
@onready var attack_speed_label: Label = $VBoxContainer/HBoxContainer2/AttackSpeedLabel

var crithit_rate := 0.2 #白字暴击率
var crithit_damage := 1.5 #白字暴击伤害

##首先 应当具备读取和修改里面的值
@export var Attribute := {
	"attack_speed" : 1.0, 
	"attack_damage" : 1.0, #攻击伤害加成
	"crithit_rate" : 1.0,
	"crithit_damage" : 1.0,
	"move_speed" : 1.0,
	"jump_hight" : 1.0
}

#全部写到一个数组里
#按照顺序是白字属性，加成属性，临时属性
@export var unify_status := {
	"attack_speed" : [10.0, 1.0, 1.0],  #白字伤害Baisc，加成伤害Modify，临时伤害Tempo
	"attack_damage" : [1.2, 1.0, 1.0],
}


func _process(delta: float) -> void:
	attack_damage_label.text = str(attack_damage * Attribute["attack_damage"])
	attack_speed_label.text = str(attack_speed * Attribute["attack_speed"])
	pass

func deal_damage(): #造成伤害
	var final_damage = attack_damage * Attribute["attack_damage"] #现场计算伤害结果
	
	#计算暴击伤害
	if randf_range(0.0, 1.0) <= crithit_rate: #本次造成的伤害为暴击伤害
		final_damage *= crithit_damage
		print("本次造成暴击伤害", final_damage)
		
	Enemy.take_damage(final_damage)


func take_damage(): #接受伤害
	pass


#获得具体值
#func get_modify_value():
	#pass

func _on_button_pressed() -> void: #按下玩家攻击键
	button.disabled = true
	deal_damage()
	await get_tree().create_timer(attack_speed * Attribute["attack_speed"]).timeout #等待攻击间隔
	button.disabled = false
