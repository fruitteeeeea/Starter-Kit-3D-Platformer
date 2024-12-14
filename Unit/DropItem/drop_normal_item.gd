extends Node3D
class_name DropNormalItem

@export var collectable := true #是否可被玩家收集
var is_collectting := false #被收集的标记
var target : Node3D #目标位置

@export var do_bounce := true
@export var random_posxz := Vector2(-2, 2)
@export var random_y := Vector2(1, 3)
@export var tween_interval := .8

@onready var model: Node3D = $Model

var is_floting := true
var time := 0.0

@export var vanish_time := 10.0 #消失时间

func _ready() -> void:
	rotate_y(randf()) #随机y轴旋转
	model.scale = Vector3.ONE * randf_range(.8, 1.2) #随机大小
	bounce_to_random_pos()
	await get_tree().create_timer(vanish_time).timeout
	queue_free() #到点自动消失


func _physics_process(delta: float) -> void:
	if is_floting:
		rotate_y(2 * delta) # Rotation
		position.y += (cos(time * 5) * 1) * delta # Sine movement
		
		time += delta
	
	if is_collectting && is_instance_valid(target):
		global_position = global_position.lerp(target.global_position, delta * 10)
		
		if global_position.distance_to(target.global_position) <.5:
			SoundManager.play_sfx("ReachPlayerSFX")
			queue_free()

#初始随机掉到某个地方
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

#玩家捡起物品
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		await get_tree().create_timer(0.25).timeout
		is_floting = false
		target = body
		is_collectting = true
