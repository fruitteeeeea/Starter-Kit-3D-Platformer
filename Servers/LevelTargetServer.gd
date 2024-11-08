extends Node
#这个服务器管理所有的玩家关卡内目标活动

var current_payload := {
	#payload #progress
}

@export var current_occupy_zone := {
	#occupy_zone #occupy_time #compelte_occupy_time
}

#添加当前关卡任务目标
func add_level_target(target01 : Node):
	#匹配任务类型
	match target01:
		pass

#玩家摧毁怪物生成点
func enemy_spwan_destory(enemy_spwan01 : Node):
	pass

#目标物被击杀
func target_enemy_dead():
	pass

#玩家完成任务点占领
func complete_occupy_zone(occupy_zone01 : Node):
	pass

#推车关卡完成
func complete_push_car():
	pass
