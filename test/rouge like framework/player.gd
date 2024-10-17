extends Control

@export var Enemy : Control #指定敌人节点
@onready var button: Button = $Button #攻击按钮

#白字属性
var attack_damage := 10.0 #白字攻击伤害
var attack_speed := 1.2

var crithit_rate := 0.2 #白字暴击率
var crithit_damage := 1.5 #白字暴击伤害

#展示标签
@onready var attack_damage_label: Label = $VBoxContainer/HBoxContainer/AttackDamageLabel
@onready var attack_speed_label: Label = $VBoxContainer/HBoxContainer2/AttackSpeedLabel
@onready var crit_hit_rate_label: Label = $VBoxContainer/HBoxContainer3/CritHitRateLabel
@onready var crit_hit_damage_label: Label = $VBoxContainer/HBoxContainer4/CritHitDamageLabel

#展示进度条
@onready var attack_damage_progressbar: ProgressBar = $VBoxContainer/HBoxContainer/VBoxContainer/AttackDamageProgressbar
@onready var attack_speed_progressbar: ProgressBar = $VBoxContainer/HBoxContainer2/VBoxContainer/AttackSpeedProgressbar


##首先 应当具备读取和修改里面的值
@export var Addition := {
	"attack_damage" : 1.0, #攻击伤害加成
	"attack_speed" : 1.0, 
	"crithit_rate" : 1.0,
	"crithit_damage" : 1.0
}

#全部写到一个数组里
#按照顺序是白字属性，加成属性，临时属性
@export var unify_status := {
	"attack_damage" : [1.2, 1.0, 1.0],
	"attack_speed" : [10.0, 1.0, 1.0],  #白字伤害Baisc，加成伤害Modify，临时伤害Tempo
	"crithit_rate" : [0.2, 1.0, 1.0],
	"crithit_damage" : [1.5, 1],
}

#记录升级的各个阶段 最初的设想是建立等级上限，等级步骤和当前等级三个参数的
@export var modify_phase := {
	"attack_damage" : [1.5, 1.75, 2.0],
	"attack_speed" : [- 0.3, -0.75, 2.0], #三个阶段
	"crithit_rate" : [3, 0],
	"crithit_damage" : [3, 0]
}

#UI元素 分别对应标签，进度条
@export var Status_UI := { 
	"attack_damage" : [attack_damage_label, attack_damage_progressbar]
}

func _process(delta: float) -> void:
	#attack_damage_label.text = str(attack_damage * Addition["attack_damage"]) + "/" + str(attack_damage) + "/" + str(Addition["attack_damage"])
	#attack_speed_label.text = str(attack_speed * Addition["attack_speed"]) + "/" + str(attack_speed) + "/" + str(Addition["attack_speed"])
	pass

func deal_damage(): #造成伤害
	var final_damage = attack_damage * Addition["attack_damage"] #现场计算伤害结果
	
	#计算暴击伤害
	if randf_range(0.0, 1.0) <= crithit_rate: #本次造成的伤害为暴击伤害
		final_damage *= crithit_damage
		print("本次造成暴击伤害", final_damage)
		
	Enemy.take_damage(final_damage)


func take_damage(): #接受伤害
	pass

#基础属性的修改
func do_basic_upgrade(status01 : String):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		print(Status_UI["attack_damage"][0], Status_UI["attack_damage"][1])


#玩家脚本中获取
func do_modify_upgrade(status01 : String):
	#先判断当前的数值不等于最终值 如果等于最终值就跳过
	if Addition[status01] == modify_phase[status01].back():
		print(("属性已达到最大值，不可再升级。"))
		return
	
	for stage_value in modify_phase[status01]: #进行升级
		if Addition[status01] < stage_value:
			Addition[status01] = stage_value
			print("属性已升级到:", Addition[status01])
			
			attack_damage_progressbar.value += .333
			attack_damage_label.text = str(attack_damage * Addition["attack_damage"]) + "/" + str(attack_damage) + "/" + str(Addition["attack_damage"])
			return  # 升级成功后退出函数

#获得临时升级
func do_tempo_upgrade(status01 : String):
	pass


func _on_button_pressed() -> void: #按下玩家攻击键
	button.disabled = true
	deal_damage()
	await get_tree().create_timer(attack_speed * Addition["attack_speed"]).timeout #等待攻击间隔
	button.disabled = false
