extends Resource
class_name DroneInfo

@export var DroneScene : PackedScene #无人机的场景

#添加无人机
func add_bot(parent01 : CharacterBody3D, pos01 : Marker3D):
	var drone = DroneScene.instantiate()
	parent01.get_tree().current_scene.add_child(drone)
	drone.position = pos01.global_position
	drone.player = parent01
	drone.follow_point  = pos01 #赋予跟踪marker3d
