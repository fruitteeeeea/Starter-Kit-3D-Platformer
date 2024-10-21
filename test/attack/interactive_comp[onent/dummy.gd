extends CharacterBody3D

@onready var model: Node3D = $model
@onready var tree_log_small_2: Node3D = $"model/tree-log-small2"

@onready var damage_number_spawn_point: Marker3D = $DamageNumberSpawnPoint

@export var floting := false

#做 sin 运动的参数
var time := 0.0
var is_floting := true

var hit_tween : Tween

func _ready() -> void:
	add_to_group("Enemy")

func _process(delta: float) -> void:
	if is_floting:
		model.rotate_y(2 * delta) # Rotation
		# Sine movement #第一个参数控制频率 第二个控制幅度
		model.position.y += (cos(time * 1) * 0.25) * delta
		
		time += delta


func do_hit_tween():
	if hit_tween:
		hit_tween.kill()
	
	is_floting = false
	var init_posy = tree_log_small_2.position.y
	tree_log_small_2.position.y = - 2.5
	hit_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	hit_tween.tween_property(tree_log_small_2, "position:y", init_posy, .3)
	await hit_tween.finished
	is_floting = true


func take_damage(damge := 1.0):
	SoundManager.play_sfx("EnemyHurtSFX", true)
	damage_number_spawn_point.spwan_damage_number(damge)
	do_hit_tween()
