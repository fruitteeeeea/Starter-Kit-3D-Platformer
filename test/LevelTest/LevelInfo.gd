extends Resource
class_name LevelInfo #管理关卡信息的类

@export var level_level := 1 #关卡等级
@export var level_loot_level := {} #关卡战利品列表 使用字典存储 分别记录各个等级的战利品占比情况
@export var level_shop_level := {} #关卡商店列表

@export var level_time := 30.0 #关卡时间
@export var payload_path : Resource #载具路径资源

@export var enemy_spwaner_list : Array[PackedScene] #敌人生成器数组
@export var level_chest_spwaner : Array[PackedScene] #奖励箱子生成器数组
@export var payload_debuff_list : Array[PackedScene] #debuff 数组
@export var payload_target_list : Array[PackedScene] #载具目标点数组

@export var level_BGM : AudioStream

#选择一个 target
func pick_payload_target():
	if payload_target_list:
		var target = payload_target_list.pick_random()
		payload_target_list.erase(target)
		return target
