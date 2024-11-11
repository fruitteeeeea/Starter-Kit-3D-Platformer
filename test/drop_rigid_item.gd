extends RigidBody3D

@export var vanished_time := 1.0
@export var model_parts := [$Model/turkey2/turkey, $Model/turkey2/turkey/leg, $Model/turkey2/turkey/leg2]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(vanished_time).timeout
	queue_free()
	#for i in model_parts:
		#do_vanished(i)



#func do_vanished(model01 : MeshInstance3D):
	#var tween = create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	#tween.tween_property(model01, "transparency", 1.0, 1.0)
