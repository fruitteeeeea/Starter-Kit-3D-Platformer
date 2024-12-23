extends LootEffect
class_name WeaponLootEffect

@export var modify_property : String
@export var modify_value : float

func apply_loot(): #玩家对应属性添加对应值
	WeaponServers.modify_info[modify_property] += modify_value
	print("修改 WeaponSatus")
