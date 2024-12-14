extends Node3D

@onready var label_3d: Label3D = $Label3D

func floating_tween(damage01):
	label_3d.text = str(damage01)
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	tween.tween_property(label_3d, "scale", Vector3(.2, .2, .2), 1.2).set_delay(.2)
	tween.tween_property(label_3d, "position:y", 1.23, 1.2).set_delay(.2)
	tween.tween_property(label_3d, "transparency", 1.0, 1.2).set_delay(.6)
	await tween.finished
	queue_free()
