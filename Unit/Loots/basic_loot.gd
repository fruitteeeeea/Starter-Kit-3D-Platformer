extends Node
class_name Loot #战利品

enum LootType {
	PlayerStatus,
	WeaponStatus,
	PayloadStatus,
	EnemyStatus
}

@export var Type := LootType.PlayerStatus

#用于 UI 展示
@export_enum("普通", "稀有", "传奇") var Rarity : String = "普通" #战利品稀有度
@export_enum("玩家", "武器", "载具", "敌人") var Tag : String = "玩家" #战利品标签
@export_enum("PlayerStatus", "WeaponStatus", "PayloadStatus", "EnemyStatus") var Property : String = "PlayerStatus" #战利品属性

@export var modify_property : String #具体属性
@export_enum("增加", "减少") var modify_method : String = "增加"
@export var modify_value : float #具体数值
@export var text_display : String

@export_multiline var Description : String #战利品描述

#稀有度和标签颜色
@export var rarity_color : Color #稀有度颜色
@export var rarity_color_array : Array[Color] = []
@export var tag_color : Color #标签颜色
@export var tag_color_array : Array[Color] = [] #分别是玩家 武器 载具 敌人 
