extends Node
#管理玩家的战利品的服务

signal loot_status_update

#所有等级词条直接添加到对应节点下
@onready var level_1_loot: Node = $level1_loot #在此节点下添加所有1级词条
@onready var level_2_loot: Node = $level2_loot
@onready var level_3_loot: Node = $level3_loot

@export var level_1_loot_list := [] #等级1战利品
@export var level_2_loot_list := [] #等级2战利品
@export var level_3_loot_list := [] #等级3战利品 

var current_loot_level := {} #当前关卡的战利品等级
var current_shop_level := {} #当前关卡的商品等级

var current_picked_loot := [] #当前呈现的战利品
var current_selected_loot := [] #当前已选择的战利品

var round_loots_nb := 0 #当前回合可选择战利品数量
var round_loots_page := 0 #当前回合可选择战利品页数

var current_loot_nb := 0 #当前已选择战利品 （直接用current_selected_loot数组大小替代
var current_loot_page := 1 #当前页面

#UI相关
@export var loot_panel : PackedScene #战利品面板
var loot_nb_page := 3 #每一页战利品数量 

func _ready() -> void: #TD 修改加载等级战利品方法
	#将各个等级下的词条子节点加入到数组中
	for loot in level_1_loot.get_children():
		level_1_loot_list.append(loot)
	
	for loot in level_2_loot.get_children():
		level_2_loot_list.append(loot)
		
	for loot in level_3_loot.get_children():
		level_3_loot_list.append(loot)

#更新当前战利品等级
func update_loot_level(info: Dictionary):
	#根据字典内容更新战利品等级分布情况
	current_loot_level.clear()
	current_loot_level = info.duplicate()


func update_shop_level(info: Dictionary):
	#根据字典内容更新商店等级分布情况
	pass

#更新战利品状态
func update_loot_status(loot_nb01 :int, loot_page01 := 1):
	round_loots_nb += loot_nb01 
	round_loots_page += loot_page01
	loot_status_update.emit()

#重置战利品状态
func reset_loot_status():
	round_loots_nb = 0
	round_loots_page = 0
	current_loot_page = 1
	current_picked_loot.clear()
	current_selected_loot.clear()

#添加可选择战利品 参数战利品等级 战利品页数
func pick_loot():
	if round_loots_page == 0:
		return
	
	var picked_loot_nb = round_loots_page * 3 #每页 3 个战利品 算出需要挑选的中战利品数量
	for i in range(picked_loot_nb):
		var picked_loot = level_1_loot_list.pick_random() #在目标等级数组中随机挑选战利品 
		current_picked_loot.append(picked_loot) #这就是当前挑选的战利品

#玩家选择战利品
func select_loot(loot01 : Loot):
	current_selected_loot.append(loot01) #目标战利品添加到当前选择列表中 

#最后就是应用修改
func apply_modify():
	for loot in current_selected_loot:
		apply_status(loot) #逐个向玩家属性字典添加对应属性

	reset_loot_status()
	loot_status_update.emit()


func apply_status(loot01 : Loot): #应用具体数据
	match loot01.Type:
		loot01.LootType.PlayerStatus: #根据战利品类型修改对应参数
			print("修改 PlayerSatus")
			var final_value = PlayerSatusServer.BasicStatus[loot01.modify_property] * loot01.modify_value
			PlayerSatusServer.ModifyStatus[loot01.modify_property] += final_value #添加对应值
		loot01.LootType.WeaponStatus:
			print("修改 WeaponSatus")
		loot01.LootType.PayloadStatus:
			print("修改 PayloadSatus")
		loot01.LootType.EnemyStatus:
			print("修改 EnemySatus")
