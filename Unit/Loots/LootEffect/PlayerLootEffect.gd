extends LootEffect
class_name PlayerLootEffect

@export var modify_property : String
@export var modify_value : float


func apply_loot(): #玩家对应属性添加对应值
		var final_value = PlayerSatusServer.BasicStatus[modify_property] * modify_value #按照倍率乘的
		PlayerSatusServer.ModifyStatus[modify_property] += final_value #添加对应值 
