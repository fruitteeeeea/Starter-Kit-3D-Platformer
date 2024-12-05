extends Node3D

@onready var spwaner: Node3D = $spwaner
@onready var list: Node3D = $List

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		for i in list.get_children():
			apply_ramdompos(i, 4, 90, .75)
			await get_tree().create_timer(.1).timeout


func apply_ramdompos(node01 : Node, distance01 : float = 3, preferred_angle : float = 0, bias : float = 0):
	
	#var preferred_angle = 180.0
	#var bias = 0.1 # 偏好程度：75% 倾向于 180 度
	var result_angle = get_biased_angle(preferred_angle, bias)
	print("Resulting angle: ", result_angle)
	spwaner.rotation_degrees.y = result_angle
	
	#spwaner.rotate_y(randf_range(0, TAU)) #设定角度
	var marker01 = Marker3D.new()
	spwaner.add_child(marker01)
	marker01.position.x = distance01 #设定距离
	
	node01.global_position = marker01.global_position
	node01.global_rotation = marker01.global_rotation
	
	marker01.queue_free()

func get_biased_angle(preferred_angle: float, bias: float) -> float:
	# preferred_angle: 偏好角度（例如 180）
	# bias: 偏好系数（0 完全随机，1 完全偏向 preferred_angle）
	var random_angle = randf_range(0.0, 360.0) # 完全随机角度
	return lerp(random_angle, preferred_angle, bias)
