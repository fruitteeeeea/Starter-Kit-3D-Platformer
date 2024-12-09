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

#获取圆周长上面的一个随机点
func get_random_point_on_circle(center: Vector2, radius: float = 1.0) -> Vector2:
	var theta = randf() * TAU  # 随机角度
	var point = Vector2(cos(theta), sin(theta)) * radius  # 圆周上的点
	return center + point  # 平移到圆心

#偏好角度
func get_biased_angle(preferred_angle: float, bias: float) -> float:
	# preferred_angle: 偏好角度（例如 180）
	# bias: 偏好系数（0 完全随机，1 完全偏向 preferred_angle）
	var random_angle = randf_range(0.0, 360.0) # 完全随机角度
	return lerp(random_angle, preferred_angle, bias)
