extends Control

@export var Enemy : Control #指定敌人节点
@onready var button: Button = $Button #攻击按钮

#UI元素 分别对应属性名称 对应节点
@export var Status_UI := {}
@export var basic_ui := preload("res://test/rouge like framework/player_status_ui.tscn") #基础UI组件

#====决定版====
#白字属性
@export var BaiscSatus := {
	"attack_damage" : 10.0,
	"attack_speed" : 1.2, 
	"crithit_rate" : 0.2,
	"crithit_damage" : 1.5
}

#升级后的属性加成
var ModifyStatus := {
	"attack_damage" : 1.0, #最开始都是 1.0
	"attack_speed" : 1.0, 
	"crithit_rate" : 1.0, 
	"crithit_damage" : 1.0
}

#基础属性升级曲线
@export var LevelingCurve := {
	"attack_damage" : [1.5, 1.75, 2.0], #对应各个阶段的升级
	"attack_speed" : [0.75, 0.5, 0.3], 
	"crithit_rate" : [2.0, 3.0, 4.0], 
	"crithit_damage" : [2.0, 2.5, 3.0]
}

var defult_modify := {} #用于重置字典

#掉落物加成
var StatusBuff := {
	"attack_damage" : [], #增加倍率
	"attack_speed" : [], 
	"crithit_rate" : [], 
	"crithit_damage" : []
}

#根据商店需要修改玩家基础数值
func do_basic_status_upgrade(upgradename : String, upgradenumber : float, dogradename : String, downgradenumber : float):
	BaiscSatus[upgradename] += upgradenumber #商店物品增益部分
	
	if dogradename && downgradenumber: #如果存在的话 这里是商店物品减益部分
		BaiscSatus[upgradename] += downgradenumber

#词条修改加成
func do_status_modify(modifyname : String):
	#先判断当前的数值不等于最终值 如果等于最终值就跳过
	if ModifyStatus[modifyname] == LevelingCurve[modifyname].back():
		print(modifyname, "已达到最大值，不可再升级。")
		return
		
	for stage_value in LevelingCurve[modifyname]: #进行升级
		if ModifyStatus[modifyname] < stage_value and LevelingCurve[modifyname][0] < LevelingCurve[modifyname][-1] or\
		ModifyStatus[modifyname] > stage_value and LevelingCurve[modifyname][0] > LevelingCurve[modifyname][-1]: #当升级数组是升序或者是降序的时候
			
			ModifyStatus[modifyname] = stage_value
			UI_update(modifyname)
			print(modifyname, "属性已升级到:", ModifyStatus[modifyname])
			
			return  # 升级成功后退出函数

#添加 buff
func do_status_buff(buffname : String, bufffactor : float, bufftime : float):
	StatusBuff[buffname].append(bufffactor) #将自身添加进数组中
	await get_tree().create_timer(bufftime).timeout #等待 buff 倒计时完成
	StatusBuff[buffname].erase(bufffactor) #将自身从数组中移除 

#查看 buff #因为buff会消失 所以增加一个数组来记录是否持有buff
func get_status_buff(buffname : String):
	if StatusBuff[buffname].size() > 0:
		return BaiscSatus[buffname] * StatusBuff[buffname][-1] #总是取最后一个值

func deal_damage():
	#首先是伤害部分
	var final_damage = BaiscSatus["attack_damage"] * ModifyStatus["attack_damage"] #现场计算伤害结果
	if get_status_buff("attack_damage"): #如果有临时 buff 的话 则加上这一部分
		final_damage += get_status_buff("attack_damage")
	
	var final_critrate = BaiscSatus["crithit_rate"] * ModifyStatus["crithit_rate"] #计算一下最终暴击率
	if get_status_buff("crithit_rate"): #如果有临时 buff 的话 则加上这一部分
		final_critrate += get_status_buff("crithit_rate")

	if randf_range(0.0, 1.0) <= final_critrate: #本次造成的伤害为暴击伤害
		final_damage *= BaiscSatus["crithit_damage"] * ModifyStatus["crithit_damage"]
	
		if get_status_buff("crithit_damage"): #如果有临时 buff 的话 则加上这一部分
			final_critrate += get_status_buff("crithit_damage")
	
	Enemy.take_damage(final_damage)

#====分割线====

func _ready() -> void:
	create_Status_UI() #根据属性设置UI
	defult_modify = ModifyStatus.duplicate() #设置一下重置的字典


func _process(delta: float) -> void:
	$"../test".text = str(player_status_text())

func take_damage(): #接受伤害
	pass

func rest_status():
	ModifyStatus = defult_modify.duplicate()
	for status in ModifyStatus:
		UI_update(status)

func create_Status_UI():
	var PlayerUIPlace = $VBoxContainer
	
	for key in ModifyStatus:
		var hbox = basic_ui.instantiate()
		print(key, ModifyStatus[key])
		PlayerUIPlace.add_child(hbox)
		hbox.updata_label(key, ModifyStatus[key])
		Status_UI[key] = hbox #添加进入UI字典
		await get_tree().create_timer(.1).timeout
 
func UI_update(status01 : String):
	#需要有名字和对应节点
	if Status_UI.has(status01):
		Status_UI[status01].updata_label(status01, ModifyStatus[status01])

func player_status_text():
	var status_arry = ["Basic Status"]
	for status in BaiscSatus:
		status_arry.append(status)
		status_arry.append(BaiscSatus[status])

	var modify_arry = ["Modify Status"]
	for modify in ModifyStatus:
		modify_arry.append(modify)
		modify_arry.append(ModifyStatus[modify])

	var buff_arry = ["Current Buff"]
	for buff in StatusBuff:
		buff_arry.append(buff)
		buff_arry.append(StatusBuff[buff])
	return status_arry + modify_arry + buff_arry

#玩家攻击
func _on_button_pressed() -> void: #按下玩家攻击键
	button.disabled = true
	deal_damage()
	await get_tree().create_timer(BaiscSatus["attack_speed"] * ModifyStatus["attack_speed"]).timeout #等待攻击间隔
	button.disabled = false

#玩家状态重置
func _on_reset_pressed() -> void: #重置所有属性
	rest_status()
