extends Node3D

var time := 0.0
var is_floting := true
var is_collectting := false
var target : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#born_tween()
	pass # Replace with function body.


func born_tween():
	print(position)
	var rand_pos = randf_range(-2, 2)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position:x", position.x + rand_pos, .3)
	tween.tween_property(self, "position:z", position.z + rand_pos, .3)
	await tween.finished
	print(position)
	is_floting = true
	pass


func _process(delta):
	if is_floting:
		rotate_y(2 * delta) # Rotation
		position.y += (cos(time * 5) * 1) * delta # Sine movement
		
		time += delta

	if is_collectting:
		global_position = global_position.lerp(target.global_position, delta * 10)
		
		if global_position.distance_to(target.global_position) <.5:
			queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		await get_tree().create_timer(0.25).timeout
		is_floting = false
		target = body
		is_collectting = true
