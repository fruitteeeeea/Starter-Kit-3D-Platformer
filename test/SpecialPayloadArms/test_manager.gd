extends Node

@export var AOE : PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		get_mouse_position()

#获取鼠标位置
func get_mouse_position():
	var pos = get_viewport().get_camera_3d().shoot_ray()
	spwan_aoe(pos)

#目标位置生成 aoe
func spwan_aoe(pos01 : Vector3):
	var aoe = AOE.instantiate()
	get_tree().current_scene.add_child(aoe)
	aoe.global_position = pos01
	aoe.rotation.y = randf()
