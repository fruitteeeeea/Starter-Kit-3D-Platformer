extends Node2D
#可以直接读取资源文件

@export var loot : LootOptions

func _ready() -> void:
	loot = load("res://test/ResourceTest/level1Loot.tres") #直接在代码中读取资源
	print(loot.loot_level)
	loot.duble_level()
	print(loot.loot_level)
