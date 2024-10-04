extends Node3D

var weapon_direction : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	face_to_mouse_cursor()


func face_to_mouse_cursor():
	var camera = get_viewport().get_camera_3d()
	if camera.has_method("shoot_ray"):
		var mouse_pos = camera.shoot_ray()
		if mouse_pos:
			look_at(Vector3(mouse_pos.x, global_position.y, mouse_pos.z))
