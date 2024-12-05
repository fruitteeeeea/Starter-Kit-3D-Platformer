extends Node

var current_actived_payloads := [] #当前活跃的车子

#获取载具周围坐标 #距离远近 #角度偏好
func GetPayloadAroundPos(distance01 : float, angle01 : float, bais01 : float,) -> Vector3:
	if !LevelTargetServer.current_actived_payloads.size():
		return Vector3.ZERO
	
	var current_payload = LevelTargetServer.current_actived_payloads.pick_random()
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

#func apply_ramdompos(node01 : Node, distance01 : float = 3, preferred_angle : float = 0, bias : float = 0):
	#
	##var preferred_angle = 180.0
	##var bias = 0.1 # 偏好程度：75% 倾向于 180 度
	#var result_angle = get_biased_angle(preferred_angle, bias)
	#print("Resulting angle: ", result_angle)
	#spwaner.rotation_degrees.y = result_angle
	#
	##spwaner.rotate_y(randf_range(0, TAU)) #设定角度
	#var marker01 = Marker3D.new()
	#spwaner.add_child(marker01)
	#marker01.position.x = distance01 #设定距离
	#
	#node01.global_position = marker01.global_position
	#node01.global_rotation = marker01.global_rotation
	#
	#marker01.queue_free()

func get_biased_angle(preferred_angle: float, bias: float) -> float:
	# preferred_angle: 偏好角度（例如 180）
	# bias: 偏好系数（0 完全随机，1 完全偏向 preferred_angle）
	var random_angle = randf_range(0.0, 360.0) # 完全随机角度
	return lerp(random_angle, preferred_angle, bias)
