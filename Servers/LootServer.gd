extends Node
#管理玩家的战利品的服务

signal loot_status_update

#var current_loot_level := {} #当前关卡的战利品等级
#var current_shop_level := {} #当前关卡的商品等级
var current_loot_level := 0 #当前关卡的战利品等级
var current_shop_level := 0 #当前关卡的商品等级

var current_picked_loot := [] #当前呈现的战利品
var current_selected_loot := [] #当前已选择的战利品 

var round_loots_nb := 0 #当前回合可选择战利品数量
var round_loots_page := 0 #当前回合可选择战利品页数

var current_loot_nb := 0 #当前已选择战利品 （直接用current_selected_loot数组大小替代
var current_loot_page := 1 #当前页面

#UI相关
@export var loot_panel : PackedScene #战利品面板
var loot_nb_page := 3 #每一页战利品数量 

#更新当前战利品等级
func update_loot_level(level01: int):
	#根据字典内容更新战利品等级分布情况
	current_loot_level = level01


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
	#在此处确定好等级
	
	for i in range(picked_loot_nb):
		var picked_loot = FileServer.loot_tres_info[current_loot_level].pick_random() #在目标等级数组中随机挑选战利品 
		current_picked_loot.append(picked_loot) #这就是当前挑选的战利品

#玩家选择战利品
func select_loot(loot01 : LootInfo):
	current_selected_loot.append(loot01) #目标战利品添加到当前选择列表中 

#最后就是应用修改
func apply_modify():
	for loot in current_selected_loot:
		apply_status(loot) #逐个向玩家属性字典添加对应属性

	reset_loot_status()
	loot_status_update.emit()


func apply_status(loot01 : LootInfo): #应用具体数据
	loot01.loot_effect.apply_loot()
