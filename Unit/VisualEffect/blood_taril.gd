extends Sprite3D

func _ready() -> void:
	frame = randi_range(0, 3) #随机一帧
	do_fade()
	#do_splash()

func do_splash():
	var target_position = self.position
	target_position.x += .5
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position", target_position, .3)
	await tween.finished


func do_fade():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "transparency", 1.0, 3.0)
	await tween.finished
	queue_free()
