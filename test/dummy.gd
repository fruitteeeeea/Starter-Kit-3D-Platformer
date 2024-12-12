extends Node3D

var target_pos : Vector3
@onready var decal: Decal = $Decal

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		find_target()

func _ready() -> void:
	add_to_group("player")

func find_target():
	var camera = get_viewport().get_camera_3d()
	var pos = camera.shoot_ray()
	target_pos = Vector3(pos.x, global_position.y, pos.z)


func _physics_process(delta: float) -> void:
	if target_pos:
		global_position = global_position.lerp(target_pos, .15)
