extends Label3D

func _ready() -> void:
	scale = scale * 0.8
	await get_tree().create_timer(.4).timeout
	fadetween()


func fadetween():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector3(0.5, 0.5, 0.5), 2)
	tween.tween_property(self, "position:y", position.y + randf_range(0.8, 1.2), 2)
	tween.tween_property(self, "transparency", 1.0, 2)
	await tween.finished
	queue_free()
