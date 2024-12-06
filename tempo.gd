extends Node3D

@export var test_scene : PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		var scene = test_scene.instantiate()
		get_tree().root.add_child(scene)
		scene.global_position = global_position
