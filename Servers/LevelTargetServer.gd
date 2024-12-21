extends Node
#这个服务器管理所有的玩家关卡内目标活动

@export var current_occupy_zone_node := []
@export var current_occupy_zone := {
	#occupy_zone #occupy_time #complete_occupy_time
}

#玩家摧毁怪物生成点
func enemy_spwan_destory(enemy_spwan01 : Node):
	pass

#目标物被击杀
func target_enemy_dead():
	pass

#玩家完成任务点占领
func complete_occupy_zone(occupy_zone01 : Node):
	pass
