extends Node

@export var level_info : LevelInfo
@export var final_level := 3 #最后一关是第3关 最后一关结束之后不会被传送到商店 而是通关关卡

#更换场景
func change_scene(path: String): #专门用于处理游戏场景切换
	var tree := get_tree()
	tree.change_scene_to_file(path)

#前往购物关卡或结算关卡
func change_to_shop_level():
	var next_level = level_info.level_level + 1
	if next_level <= final_level:
		change_scene(FileServer.shop_level_scene) #在这个位置判断是否还有最后一关
	else:
		change_scene(FileServer.final_level_scene)

#前往下个游戏关卡
func change_to_next_level():
	var level_arry = FileServer.get_next_level_scene(level_info) #获取数组
	var level_scene01 = level_arry[0] #获取下一个关卡的地址
	var level_info01 = level_arry[1] #获取下一个关卡的关卡信息
	
	level_info = load(level_info01) #更新关卡信息 #先加载再赋值
	change_scene(level_scene01) #更换关卡场景
