extends Node
#这个服务器管理所有的玩家关卡内目标活动

@export var current_payload := {
	#payload #progress
}
var current_actived_payloads := [] #当前活跃的车子

@export var current_occupy_zone_node := []
@export var current_occupy_zone := {
	#occupy_zone #occupy_time #complete_occupy_time
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


#===推车相关===
func add_payload(payload01 : PathFollow3D):
	current_payload[payload01] = 0.0 #登记车子
	payload01.payload_move.connect(_payload_move) #管理器信号链接
	payload01.payload_stop.connect(_payload_stop)
	payload01.payload_complete.connect(_payload_complete)
	
	var label = payload01.label.instantiate()
	label.payload = payload01
	payload01.payload_move.connect(label._payload_move)
	payload01.payload_stop.connect(label._payload_stop)
	Hud.add_child(label)


func _payload_move(payload01):
	current_actived_payloads.append(payload01)
	pass


func _payload_stop(payload01):
	current_actived_payloads.clear()
	pass

#完成推车
func _payload_complete(payload01):
	LootServer.show_loot_panel()
