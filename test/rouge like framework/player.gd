extends Control

@export var Enemy : Control #指定敌人节点
@onready var button: Button = $Button #攻击按钮

##首先 应当具备读取和修改里面的值
@export var Addition := {
	"attack_damage" : 1.0, #攻击伤害加成
	"attack_speed" : 1.0, 
	"crithit_rate" : 1.0,
	"crithit_damage" : 1.0
}

var defult_addition := {} #用于重置字典

#全部写到一个数组里
#按照顺序是白字属性，加成属性，临时属性
@export var unify_status := {
	"attack_damage" : [1.2, 1.0, 1.0],
	"attack_speed" : [10.0, 1.0, 1.0],  #白字伤害Baisc，加成伤害Modify，临时伤害Tempo
	"crithit_rate" : [0.2, 1.0, 1.0],
	"crithit_damage" : [1.5, 1.0, 1.0],
}

#记录升级的各个阶段 最初的设想是建立等级上限，等级步骤和当前等级三个参数的
@export var modify_phase := {
	"attack_damage" : [1.5, 1.75, 2.0],
	"attack_speed" : [0.75, 0.5, 0.3], #三个阶段
	"crithit_rate" : [2.0, 3.0, 4.0], 
	"crithit_damage" : [2.0, 2.5, 3.0]
}

#UI元素 分别对应属性名称 对应节点
@export var Status_UI := {}

@export var basic_ui := preload("res://test/rouge like framework/player_status_ui.tscn")

#====决定版====
#白字属性
@export var BaiscSatus := {
	"attack_damage" : 10.0,
	"attack_speed" : 1.2, 
	"crithit_rate" : 0.2,
	"crithit_damage" : 1.5
}

#基础属性升级曲线
@export var LevelingCurve := {
	"attack_damage" : [1.5, 1.75, 2.0], #对应各个阶段的升级
	"attack_speed" : [0.75, 0.5, 0.3], 
	"crithit_rate" : [2.0, 3.0, 4.0], 
	"crithit_damage" : [2.0, 2.5, 3.0]
}

#升级后的属性加成
var ModifyStatus := {
	"attack_damage" : 1.0, #最开始都是 1.0
	"attack_speed" : 1.0, 
	"crithit_rate" : 1.0, 
	"crithit_damage" : 1.0
}

#掉落物加成
var StatusBuff := {
	"attack_damage" : [], #增加倍率
	"attack_speed" : [], 
	"crithit_rate" : [], 
	"crithit_damage" : []
}

#添加 buff
func do_status_buff(buffname : String, bufffactor : float, bufftime : float):
	StatusBuff[buffname].append(bufffactor) #将自身添加进数组中
	await get_tree().create_timer(bufftime).timeout #等待 buff 倒计时完成
	StatusBuff[buffname].erase(bufffactor) #将自身从数组中移除 

#查看 buff
func get_status_buff(buffname : String):
	if StatusBuff[buffname].size() > 0:
		return BaiscSatus[buffname] * StatusBuff[buffname][-1] #总是取最后一个值

func deal_damage02():
	#首先是伤害部分
	var final_damage = BaiscSatus["attack_damage"] * ModifyStatus["attack_damage"] #现场计算伤害结果
	if get_status_buff("attack_damage"): #如果有临时 buff 的话 则加上这一部分
		final_damage += get_status_buff("attack_damage")
	
	var final_critrate = BaiscSatus["crithit_rate"] * Addition["crithit_rate"] #计算一下最终暴击率
	if get_status_buff("crithit_rate"): #如果有临时 buff 的话 则加上这一部分
		final_critrate += get_status_buff("crithit_rate")

	if randf_range(0.0, 1.0) <= final_critrate: #本次造成的伤害为暴击伤害
		final_damage *= BaiscSatus["crithit_damage"] * Addition["crithit_damage"]
	
		if get_status_buff("crithit_damage"): #如果有临时 buff 的话 则加上这一部分
			final_critrate += get_status_buff("crithit_damage")
	
	Enemy.take_damage(final_damage)

#====分割线====

func _ready() -> void:
	create_Status_UI() #根据属性设置UI
	defult_addition = Addition.duplicate() #设置一下重置的字典

func deal_damage(): #造成伤害
	var final_damage = BaiscSatus["attack_damage"] * Addition["attack_damage"] #现场计算伤害结果
	
	var final_critrate = BaiscSatus["crithit_rate"] * Addition["crithit_rate"] #计算一下最终暴击率
	#计算暴击伤害
	if randf_range(0.0, 1.0) <= final_critrate: #本次造成的伤害为暴击伤害
		final_damage *= BaiscSatus["crithit_damage"] * Addition["crithit_damage"]
		print("本次造成暴击伤害", final_damage)
		
	Enemy.take_damage(final_damage)


func _process(delta: float) -> void:
	$"../test".text = str(StatusBuff)



func take_damage(): #接受伤害
	pass

#基础属性的修改
func do_basic_upgrade(status01 : String):
	pass


#玩家脚本中获取
func do_modify_upgrade(status01 : String):
	#先判断当前的数值不等于最终值 如果等于最终值就跳过
	if Addition[status01] == modify_phase[status01].back():
		print(status01, "已达到最大值，不可再升级。")
		return
	
	for stage_value in modify_phase[status01]: #进行升级
		if Addition[status01] < stage_value and modify_phase[status01][0] < modify_phase[status01][-1] or\
		Addition[status01] > stage_value and modify_phase[status01][0] > modify_phase[status01][-1]: #当升级数组是升序或者是降序的时候
			
			Addition[status01] = stage_value
			UI_update(status01)
			print(status01, "属性已升级到:", Addition[status01])
			
			return  # 升级成功后退出函数

func rest_status():
	Addition = defult_addition.duplicate()
	for status in Addition:
		UI_update(status)

func create_Status_UI():
	var PlayerUIPlace = $VBoxContainer
	
	for key in Addition:
		var hbox = basic_ui.instantiate()
		print(key, Addition[key])
		PlayerUIPlace.add_child(hbox)
		hbox.updata_label(key, Addition[key])
		Status_UI[key] = hbox #添加进入UI字典
		await get_tree().create_timer(.1).timeout
 
func UI_update(status01 : String):
	#需要有名字和对应节点
	if Status_UI.has(status01):
		Status_UI[status01].updata_label(status01, Addition[status01])

#获得临时升级
func do_tempo_upgrade(status01 : String):
	pass


func _on_button_pressed() -> void: #按下玩家攻击键
	button.disabled = true
	deal_damage02()
	await get_tree().create_timer(BaiscSatus["attack_speed"] * Addition["attack_speed"]).timeout #等待攻击间隔
	button.disabled = false


func _on_reset_pressed() -> void: #重置所有属性
	rest_status()
