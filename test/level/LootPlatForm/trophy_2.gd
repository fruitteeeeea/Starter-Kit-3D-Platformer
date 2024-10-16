extends Node3D

var time := 0.0

func _process(delta):
	
	rotate_y(2 * delta) # Rotation
	position.y += (cos(time * 5) * 1) * delta # Sine movement
	
	time += delta
