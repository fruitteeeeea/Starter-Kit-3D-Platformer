extends RigidBody3D

var force := 2800

func _ready() -> void:
	add_to_group("Box")


func get_hit(source : Vector3):
	apply_central_force((global_position - source).normalized() * force)
