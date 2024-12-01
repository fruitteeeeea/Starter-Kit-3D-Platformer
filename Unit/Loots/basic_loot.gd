extends Node
class_name Loot #战利品

enum LootType {
	Player, #用于玩家的战利品
	Weapon, #用于武器的战利品
	Payload,
	Enemy
}

enum LootTag {
	PlayerStatus,
	WeaponStatus,
}

@export var Type := LootType.Player #战利品种类
@export var Tag := LootTag.PlayerStatus #战利品标签

@export_enum("1:1", "2", "3") var Level: int = 1

@export var modify_property : String #具体属性
@export var modify_value : float #具体数值

#用于 UI 展示
@export var loot_name : String = "战利品名字"
@export var loot_tag : String = "战利品标签"
@export var loot_porperty : = "战利品属性"
@export var loot_descrption : String = "战利品描述"

var test_type : String
var test_id : int

#debug 用
func _ready() -> void:
	test_type = ["player", "weapon", "payload", "enemy"].pick_random()
	test_id = [1, 2, 3].pick_random()
	name = str(test_type, test_id)
	Type = [LootType.Player, LootType.Weapon, LootType.Payload, LootType.Enemy].pick_random()
