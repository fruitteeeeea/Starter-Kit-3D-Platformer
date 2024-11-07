extends PathFollow3D

var player_near := false
var max_move_speed := 0.05
var current_move_speed := 0.0

func _physics_process(delta: float) -> void:
	if player_near:
		#progress_ratio += delta * .05
		current_move_speed = lerpf(current_move_speed, max_move_speed, 0.1)
	else :
		current_move_speed = lerpf(current_move_speed, 0.0, 0.1)
	
	progress_ratio += delta * current_move_speed

func _on_area_3d_body_entered(body: Node3D) -> void:
	player_near = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	player_near = false
