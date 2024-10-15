extends CharacterBody3D

@export var speed = 5.6
var direction = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_visible_on_screen_enabler_3d_screen_exited() -> void:
	queue_free()
	pass
