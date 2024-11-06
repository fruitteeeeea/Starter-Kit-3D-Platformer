extends Node

var level_information := {
	"level_time" : 0.0, #关卡时间
	
	"level_loot_nb" : 0, #关卡战利品数量
	"levbel_debuff_nb" : 0, #关卡中debuff的数量
	"level_target_nb" : 0, #关卡中任务目标数
	"level_target_pool" : [], #任务目标池子
	
	"enemy_spwaner" : 0, #怪物生成点数量
	"enemy_spwaner_posy" : 0.0, #怪物生成y 坐标
	"enemy_spwaner_pos_limit" : [], #怪物生成坐标限制
	"enemy_spwan_point_pool" : [], #怪物生成点池子
	"enemy_power" : 0.0, #怪物强度
	
	"dynamic_difficulty" : false #动态难度
}

@onready var level_timer: Timer = $LevelTimer

#关卡开始
func level_start():
	#启动机计时器
	level_timer.wait_time = level_information["level_time"]
	level_timer.start()

	#启动刷怪点
	for spwaner in level_information["enemy_spwan_point_pool"]:
		EnemyStatusServer.add_enemy_spwaner(spwaner)
	
	#启动 debuff 生成
	
	pass

#关卡完成
func level_complete():
	#展示战利品结算界面
	#展示商店？
	pass

#玩家摧毁怪物生成点
func enemy_spwan_destory():
	pass

#目标物被击杀
func target_enemy_dead():
	pass

#玩家进入占领空间
func player_enter_occupy_zone():
	pass

#玩家离开占领空间
func player_exit_occupy_zone():
	pass

#推车关卡
func push_car():
	pass

#推测关卡完成
func complete_push_car():
	pass


func _on_level_timer_timeout() -> void:
	level_complete()
	pass # Replace with function body.
