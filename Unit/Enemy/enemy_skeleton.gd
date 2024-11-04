extends CharacterBody3D

signal enemy_dead(enemy : CharacterBody3D)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D #开始导航
@export var do_navigate := false #是否执行导航

@export var floting := false

#生命值部分
@export var health_component : Node
@onready var damage_number_spawn_point: Marker3D = $DamageNumberSpawnPoint #受击数字生成
@onready var drop_item_point: Marker3D = $DropItemPoint

@onready var blood_taril_pos: Marker3D = $BloodTarilPos #血迹生成点
@export var BloodTrail : PackedScene #血迹

var speed = 1.2
const JUMP_VELOCITY = 4.5
var direction = Vector3.ZERO

var gravity = -25

enum State {
	CHASE,
	KNOCKBACK
}

var player : CharacterBody3D
var chase_player := true

var knockback_strength := 20.0
var current_state: State = State.CHASE
var knockback_timer: float = 0.0
@export var knockback_duration: float = 1.0

#击中闪烁
var body_parts = [ #身体部分
	$"character-skeleton/root/torso/head", $"character-skeleton/root/torso/arm-right",
	$"character-skeleton/root/torso/arm-left", $"character-skeleton/root/torso", 
	$"character-skeleton/root/leg-right", $"character-skeleton/root/leg-left"
]
var hit_flash_material := preload("res://test/enemy/hit_flash_surface_material.tres")

func _ready() -> void:
	add_to_group("Enemy")
	await get_tree().create_timer(randf_range(.1, .5)).timeout
	animation_player.play("sprint")
	player = get_tree().get_first_node_in_group("player")
	
	#随机化
	speed = randf_range(1.2, 1.8)
	var rand_scale = randf_range(0.8, 1.2)
	scale = Vector3(rand_scale, rand_scale, rand_scale)


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y = gravity

	match current_state:
		State.CHASE:
			handle_chase_player()
		State.KNOCKBACK:
			handle_konckback(delta)
	
	if !chase_player:
		velocity = Vector3.ZERO

	move_and_slide()

#启用导航
func handle_navigation():
	navigation_agent_3d.set_target_position(player.global_position)

	#导航抓捕玩家
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	direction = local_destination.normalized()

#追逐玩家和被击退
func handle_chase_player():
	if is_instance_valid(player) && is_on_floor() && chase_player:
		if do_navigate:
			handle_navigation()
		else :
			direction = (player.global_position - global_position).normalized()
		
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		velocity = direction * speed


func apply_knockback(from_position: Vector3) -> void:
	current_state = State.KNOCKBACK
	knockback_timer = knockback_duration
	var knockback_direction = (global_position - from_position).normalized()
	velocity = knockback_direction * knockback_strength

#处理
func handle_konckback(delta: float) -> void:
	if knockback_timer > 0:
		knockback_timer -= delta
	else:
		current_state = State.CHASE

func take_damage(damge := 1.0):
	$GPUParticles3D.emitting = true
	
	SoundManager.play_sfx("EnemyHurtSFX", true)
	do_hit_flash() #受击反馈
	VisualServer.spwan_bloodtrail(BloodTrail, blood_taril_pos.global_position, global_rotation) #生成血迹
	damage_number_spawn_point.spwan_damage_number(damge)
	
	if health_component:
		health_component.damage(damge)
	
	if health_component.health <= 0:
		enemy_dead.emit(self) #先发送信号到生成节点
		chase_player = false
		animation_player.play("die")
		await animation_player.animation_finished
		await get_tree().create_timer(randf_range(.5, .8)).timeout
		
		drop_item_point.add_pineapple()
		SoundManager.play_sfx("EnemyDeadSFX", true)
		queue_free()

#指定受击反馈物体 闪红
func do_hit_flash():
	for parts in body_parts:
		hit_flash(parts)

#具体操作 闪红
func hit_flash(part01 : MeshInstance3D):
	part01.set_surface_override_material(0, hit_flash_material)
	await get_tree().create_timer(.25).timeout
	part01.set_surface_override_material(0, null)
