extends LootEffect
class_name EnemyLootEffect

@export var modify_property : String
@export var modify_value : float

func apply_loot():
	print("修改 EnemySatus")
