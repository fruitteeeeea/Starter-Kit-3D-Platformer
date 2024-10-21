extends Node3D

signal enemy_dead(enemy : CharacterBody3D)

@onready var floor_hole_2: Node3D = $"floor-hole2"
@onready var model: Node3D = $model
@onready var tree_log_small_2: Node3D = $"model/tree-log-small2"
@onready var particles: CPUParticles3D = $Particles

@onready var timer: Timer = $Timer

#做 sin 运动的参数
var time := 0.0
var is_floting := true

var up_tween : Tween
var down_tween : Tween

var is_randomdebuff := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_born_tween()
	
	if is_randomdebuff: #如果是战场上的随机 debuff
		await get_tree().create_timer(randi_range(8, 12)).timeout
		charge_complete()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_floting:
		model.rotate_y(2 * delta) # Rotation
		# Sine movement #第一个参数控制频率 第二个控制幅度
		model.position.y += (cos(time * 1) * 0.25) * delta
		
		time += delta

func do_born_tween():
	particles.emitting = true
	tree_log_small_2.position.y = -0.747
	
	up_tween = create_tween()
	up_tween.set_ease(Tween.EASE_OUT)
	up_tween.set_trans(Tween.TRANS_BOUNCE)
	up_tween.tween_property(tree_log_small_2, "position:y", 1.035, 1.55)
	await up_tween.finished
	particles.emitting = false

#完成充能
func charge_complete():
	particles.emitting = true
	
	down_tween = create_tween()
	down_tween.set_ease(Tween.EASE_OUT)
	down_tween.set_trans(Tween.TRANS_EXPO)
	down_tween.tween_property(tree_log_small_2, "position:y", -0.747, .55)
	await down_tween.finished
	queue_free()
