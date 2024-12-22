extends Node

#payload #progress #这个字典存储车子节点以及车子的进度
@export var current_payload := { }

var current_actived_payloads := [] #当前活跃的车子
var current_payload_arms : Array[PackedScene] #当前存在的载具武装

#====注册车子相关====
func add_payload(payload01 :  MovePayload):
	current_payload[payload01] = 0.0 #登记车子
	payload01.payload_move.connect(_payload_move) #管理器信号链接
	payload01.payload_stop.connect(_payload_stop)
	payload01.payload_complete.connect(_payload_complete)
	
	add_payload_arms(payload01) #添加武装
	
	var label = payload01.label.instantiate() #UI 相关
	label.payload = payload01
	payload01.payload_move.connect(label._payload_move)
	payload01.payload_stop.connect(label._payload_stop)
	Hud.add_child(label)


func _payload_move(payload01):
	current_actived_payloads.append(payload01)


func _payload_stop(payload01):
	current_actived_payloads.clear()

#完成推车
func _payload_complete(payload01):
	var loot_nb01 = 1 #完成推车增加1个战利品 
	for i in range(payload01.complete_debuff.size()):
		loot_nb01 += 1 #每个完成的debuff挑战增加1个战利品
	
	LootServer.update_loot_status(loot_nb01, 1)

#为车子添加武装
func add_payload_arms(payload01: MovePayload): 
	for arm in current_payload_arms:
		var arm01 = arm.instantiate()
		payload01.arms.add_child(arm01) #节点添加至载具下




#获取载具周围坐标 #距离远近 #角度偏好
func GetPayloadAroundPos(distance01 : float, angle01 : float, bais01 : float,) -> Vector3:
	#if !current_actived_payloads.size():
		#return Vector3.ZERO
	#
	var current_payload = current_actived_payloads.pick_random()
	if !current_payload:
		return Vector3.ZERO
	
	var result_angle = get_biased_angle(angle01, bais01)
	current_payload.anchor.rotation_degrees.y = result_angle #设定角度
	
	var marker01 = Marker3D.new()
	current_payload.anchor.add_child(marker01)
	marker01.position.x = distance01 #设定距离
	
	var final_pos = marker01.global_position
	marker01.queue_free()
	
	return final_pos

#func GetPayloadAroundPos(distance01 : float, angle01 : float, bais01 : float) -> Vector3:
	#var current_payload = current_actived_payloads.pick_random()
	#if !current_payload:
		#return Vector3.ZERO
	#
	#var result_angle = get_biased_angle(angle01  + current_payload.anchor.rotation.x, bais01) #获得角度
	#var final_pos = get_random_point_on_circle(result_angle, Vector2(current_payload.global_position.x, current_payload.global_position.z), distance01)
	#return Vector3(final_pos.x, current_payload.global_position.y, final_pos.y)


#获取圆周长上面的一个随机点
func get_random_point_on_circle(theta : float, center: Vector2, radius: float = 1.0) -> Vector2:
	#var theta = randf() * TAU  # 随机角度
	var point = Vector2(cos(theta), sin(theta)) * radius  # 圆周上的点
	return center + point  # 平移到圆心

#偏好角度
func get_biased_angle(preferred_angle: float, bias: float) -> float:
	# preferred_angle: 偏好角度（例如 180）
	# bias: 偏好系数（0 完全随机，1 完全偏向 preferred_angle）
	var random_angle = randf_range(0.0, 360.0) # 完全随机角度
	return lerp(random_angle, preferred_angle, bias)
