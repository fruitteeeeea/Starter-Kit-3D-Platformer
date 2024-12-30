extends Marker3D

@export var item01 : Array[PackedScene]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		for i in range(100):
			spwan_object()
			await get_tree().create_timer(.01).timeout

func spwan_object():
	var item = item01.pick_random().instantiate()
	get_tree().root.add_child(item)
	item.position = global_position 
	
	var random_offset = Vector3(randf_range(-45, 45), 1, randf_range(-45, 45))
	item.rotation += random_offset 
