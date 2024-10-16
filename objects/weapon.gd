extends Node3D

var weapon_direction : Vector3

func _physics_process(delta: float) -> void:
	face_to_mouse_cursor()

#只有一个面向鼠标的功能
func face_to_mouse_cursor():  
	var camera = get_viewport().get_camera_3d()
	if camera.has_method("shoot_ray"):
		var mouse_pos = camera.shoot_ray()
		if mouse_pos:
			look_at(Vector3(mouse_pos.x, global_position.y, mouse_pos.z))
