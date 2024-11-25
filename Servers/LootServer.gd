extends Node
#管理玩家的战力品的服务

var current_loot_pool := [] #当前可选择战利品的池子
var current_selected_loot := [] #当前已选择的战利品


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
