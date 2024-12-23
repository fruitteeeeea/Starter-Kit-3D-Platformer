extends Resource
class_name LootInfo
#此资源文件记载这战利品的信息

@export_enum("普通", "稀有", "传奇") var Rarity : String = "普通" #战利品稀有度
@export_enum("玩家", "武器", "载具", "敌人") var Tag : String = "玩家" #战利品标签

@export_multiline var Description : String = "未设置描述" #战利品描述

#稀有度和标签颜色
@export var rarity_color : Color #稀有度颜色 低 8d5ed44d 中 8d5ed499 高 8d5ed4
@export var tag_color : Color #标签颜色 #玩家 b6d53c 武器 fc683b 载具 2cc5f6 敌人 ffbd1f

#战利品效果也是使用一个资源文件
@export var loot_effect : LootEffect 

func get_attribute_text() -> String:
	#根据 loot_effect的效果撰写描述
	var text = "未设置属性"
	
	if loot_effect is PlayerLootEffect: 
		text = loot_effect.modify_property + str(loot_effect.modify_value)
	
	if loot_effect is PayloadLootEffect:
		text = "添加" + loot_effect.ArmsName
	
	return text


func get_description_text() -> String:
	return Description
