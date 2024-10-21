extends CharacterBody3D

@export var speed = 5.6
var direction = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

#进行旋转
func do_rotation():
	#var angle := randf_range(-1, 1)
	#var rotation_axis := Vector3(0, 1, 0)
	#direction = direction.rotated(rotation_axis, angle)
	pass


func _on_visible_on_screen_enabler_3d_screen_exited() -> void:
	queue_free()
	pass
