extends Node3D

@onready var floor_hole_2: Node3D = $"floor-hole2"
@onready var tree_log_small_2: Node3D = $"tree-log-small2"
@onready var particles_trail: CPUParticles3D = $ParticlesTrail

var born_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_born_tween()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		do_born_tween()

func do_born_tween():
	if born_tween:
		born_tween.kill()
	
	particles_trail.emitting = true
	tree_log_small_2.position.y = -0.747
	
	born_tween = create_tween()
	born_tween.set_ease(Tween.EASE_OUT)
	born_tween.set_trans(Tween.TRANS_BOUNCE)
	born_tween.tween_property(tree_log_small_2, "position:y", 1.035, 1.55)
	await born_tween.finished
	particles_trail.emitting = false
