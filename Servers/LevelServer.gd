extends Node

var level_information := {
	"level_time" : 0.0, #关卡时间
	
	"level_loot_nb" : 0, #关卡战利品数量
	"levbel_debuff_nb" : 0, #关卡中debuff的数量
	"level_target_nb" : 0, #关卡中任务目标数
	"level_target_pool" : [], #任务目标池子
	
	"enemy_spwaner" : 0, #怪物生成点数量
	"enemy_spwan_point_pool" : [], #怪物生成点池子
	
	#"enemy_spwaner_posy" : 0.0, #怪物生成y 坐标
	#"enemy_spwaner_pos_limit" : [], #怪物生成坐标限制

	"enemy_power" : 0.0, #怪物强度
	
	"dynamic_difficulty" : false #动态难度
}

@export var level_time := 45.0 #任务时间
@export var enemy_spwaner : Array[PackedScene] #怪物生成器


@onready var level_timer: Timer = $LevelTimer



var LevelList := [] #任务列表
var current_level := Node #当前关卡





#关卡开始 #离开区域以开始游戏
func level_start():
	#启动刷怪点
	for spwaner in level_information["enemy_spwan_point_pool"]:
		EnemySpwanerServer.add_enemy_spwaner(spwaner)
		pass
	
	#启动任务目标
	for target in level_information["level_target_pool"]:
		LevelTargetServer.add_level_target(target)
	
	#启动 debuff 生成
	

	#启动机计时器
	level_timer.wait_time = level_information["level_time"]
	level_timer.start()

#关卡完成
func level_complete():
	#判断玩家是否完成关卡目标
	#否 玩家失败
	#是 玩家进入过渡层
	
	#展示战利品结算界面
	#展示商店？
	
	#关卡
	pass


func _on_level_timer_timeout() -> void:
	level_complete()
