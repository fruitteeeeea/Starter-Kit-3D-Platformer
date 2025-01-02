extends RayCast3D

func _process(delta: float) -> void:
	if is_colliding():
		var obj = get_collider()
		if obj.has_method("player"):
			object_get_hit(obj)

func object_get_hit(player01 : Node):
	VisualServer.do_camerashake(.8)
	#VisualServer.hit_stop_medium(.02, .05)
	
	var direction = (player01.global_position - global_position).normalized()
	var speed = 24
	player01.velocity = direction * speed
	player01.jump()
