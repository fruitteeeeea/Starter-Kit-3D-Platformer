extends Label


var fade_tween : Tween

func fadetween(damage_number01 : float):
	text = str(damage_number01)
	modulate.a = 1.0
	scale = Vector2.ONE
	
	if fade_tween:
		fade_tween.kill()
	
	fade_tween = create_tween()
	fade_tween.set_ease(Tween.EASE_OUT)
	fade_tween.set_trans(Tween.TRANS_EXPO)
	fade_tween.set_parallel()
	fade_tween.tween_property(self, "scale", Vector2(.8, .8), 5)
	fade_tween.tween_property(self, "position:y", position.y - randf_range(80, 120), 5)
	fade_tween.tween_property(self, "modulate:a", 0.0, 5)
