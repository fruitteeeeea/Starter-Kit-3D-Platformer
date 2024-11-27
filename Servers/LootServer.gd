extends Node
#管理玩家的战利品的服务

var current_loot_pool := [] #当前可选择战利品的池子
var current_selected_loot := [] #当前已选择的战利品

var round_loots_nb := 0 #当前回合可选择战利品数量
var round_loots_page := 1 #当前回合可选择战利品页数

#UI相关
@export var loot_panel : PackedScene #战利品面板
var loot_nb_page := 3 #每一页战利品数量 

#显示战利品UI
func show_loot_panel():
	if !Hud.current_LootUI: #向hud节点添加战利品ui
		var ui = loot_panel.instantiate()
		
		#在这里定制loot_panel 
		#选择loot_option词条
		
		Hud.loot_panel_pos.add_child(ui)
		Hud.current_LootUI = ui #设置为当前战利品UI
	
	Hud.current_LootUI.show()

#添加可选择战利品
func add_loots():
	pass

#玩家选择战利品
func select_loot(loot01 : PackedScene):
	pass

#最后就是应用修改
func apply_modify():
	for loot in current_selected_loot:
		
		pass #逐个向玩家属性字典添加对应属性
	pass
