extends Node


#生成受击粒子

#生成血迹 #血迹场景 #血迹位置 #血迹旋转
func spwan_bloodtrail(blood01 : PackedScene, pos01 : Vector3, rotate01 : Vector3):
	var blood_trail = blood01.instantiate()
	get_tree().root.add_child(blood_trail)
	blood_trail.global_position = pos01 #设置位置
	blood_trail.global_rotation = rotate01 #设置方向
	blood_trail.rotation_degrees.x = 90
