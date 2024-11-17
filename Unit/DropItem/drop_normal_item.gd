extends Node3D
class_name DropNormalItem

@export var do_bounce := true
@export var random_posxz := Vector2(-2, 2)
@export var random_y := Vector2(1, 3)
@export var tween_interval := 1

@onready var model: Node3D = $Model

var is_floting := true
var time := 0.0
var is_collectting := false

func _ready() -> void:
	model.scale = Vector3.ONE * randf_range(.8, 1.2) #随机大小
	bounce_to_random_pos()


func _physics_process(delta: float) -> void:
	if is_floting:
		rotate_y(2 * delta) # Rotation
		position.y += (cos(time * 5) * 1) * delta # Sine movement
		
		time += delta

func bounce_to_random_pos():
	var random_posx = randf_range(random_posxz.x, random_posxz.y)
	var random_posz = randf_range(random_posxz.x, random_posxz.y)
	var random_posy = randf_range(random_y.x, random_y.y)
	var orgin_posy = position.y
	
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position:x", position.x + random_posx, tween_interval)
	tween.tween_property(self, "position:z", position.z + random_posz, tween_interval)
	tween.tween_property(self, "position:y", position.y + random_posy, 0.1)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position:y", orgin_posy, tween_interval - 0.1).set_delay(0.1)
