extends Node
class_name Loot #战利品

enum LootType {
	Player, #用于玩家的战利品
	Weapon, #用于武器的战利品
	Payload,
	Enemy
}

enum LootLevel {
	one,
	two,
	three
}

@export var Type := LootType.Player #战利品种类s
@export_enum("1:1", "2", "3") var Level: int = 1

@export var modify_property : String #具体属性
@export var modify_value : float #具体数值
