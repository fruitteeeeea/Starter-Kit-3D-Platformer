extends CharacterBody3D


signal enemy_dead (enenmy01 : CharacterBody3D)

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var LifeTime := 30.0 #生命时间
@onready var lifetime: Timer = $Lifetime

var player : CharacterBody3D
var direction := Vector3.ZERO
var chase_speed := 1.2 #追逐玩家的速度

var overall_strength : float #整体敌人强度

@export var knockback_recover := .1 * 2 #击退中的恢复速度
var knockback_direction : Vector3 #击退方向 相对于玩家的位置
var knockback_strength : float #攻击来源的击退强度

@onready var state_chart: StateChart = $StateChart
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#生命值相关
@export var health_component: Node

#视觉效果
@export var hurt_particle : PackedScene #击中特效
@export var blood_trail : PackedScene #死亡血迹
@onready var blood_taril_pos: Marker3D = $BloodTarilPos

#击中闪烁 #身体部分
var body_parts = [ 
	$"character-skeleton/root/torso/head", $"character-skeleton/root/torso/arm-right",
	$"character-skeleton/root/torso/arm-left", $"character-skeleton/root/torso", 
	$"character-skeleton/root/leg-right", $"character-skeleton/root/leg-left"
]

@export var hit_flash_material : Material #受击时显示的材质

var is_dying := false #处于这个状态的不在执行任何操作
@onready var normal_item_spwaner: Marker3D = $NormalItemSpwaner #死亡掉落物

func _ready() -> void:
	if LifeTime: #自动销毁敌人
		lifetime.start(LifeTime)


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 25 * delta
	
	move_and_slide()


func state_enemy():
	pass

func _on_idle_state_physics_processing(delta: float) -> void:
	if is_on_floor():
		state_chart.send_event("to_chase")
	#else:
		#velocity += get_gravity() * delta
		#velocity.y -= 25 * delta


#进入追逐状态
func _on_chase_state_entered() -> void:
	animation_player.play("walk")


func _on_chase_state_physics_processing(delta: float) -> void:
	if is_on_floor():
		chase_player()
	else :
		state_chart.send_event("to_idle")

#追逐玩家
func chase_player():
	var player = get_tree().get_first_node_in_group("player")
	
	if !player: #如果没有玩家 则返回闲置状态
		state_chart.send_event("to_idle")
	
	direction = (player.global_position - global_position).normalized() #获取玩家方向
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP) #朝向玩家
	velocity = direction * chase_speed #追逐方向和追逐速度

#攻击玩家
func attack_player():
	pass

#受到伤害
func take_damage(knockback_strength01 : float, damge : float):
	if is_dying:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	knockback_direction = (global_position - player.global_position).normalized() * 3 + Vector3(0, 3, 0) #加一个向上的力
	knockback_strength  = knockback_strength01
	
	#在这里结算生命值
	if health_component:
		health_component.damage(damge)
	
	if health_component.health <= 0:
		is_dying = true
		normal_item_spwaner.spwan_normal_item()
		#state_chart.send_event("to_dead")
		#enemy_dead.emit(self)
		#queue_free()

	state_chart.send_event("to_hurt")

#进入受伤状态
func _on_hurt_state_entered() -> void:
	#effect
	VisualServer.spwan_hurt_particle(hurt_particle, global_position)
	VisualServer.do_hit_flash(body_parts, hit_flash_material)
	SoundManager.play_sfx("EnemyHurtSFX", true)
	VisualServer.spwan_bloodtrail(blood_trail, blood_taril_pos.global_position, global_rotation) #生成血迹

	if is_dying:
		animation_player.play("die")
	else:
		animation_player.play("fall")

#进入到击退状态
func _on_hurt_state_physics_processing(delta: float) -> void:
	velocity = knockback_direction * knockback_strength
	if !is_on_floor():
		velocity.y -= 25 * delta
	
	knockback_strength = lerpf(knockback_strength, 0, knockback_recover) #从击退中回复过来
	
	if knockback_strength < 0.1:
		if is_dying:
			state_chart.send_event("to_dead")
		else:
			state_chart.send_event("to_idle")

#进入死亡状态
func _on_dead_state_entered() -> void:
	die()

#死亡方法
func die(drop_item := true):
	enemy_dead.emit(self)
	
	#if drop_item:
		#normal_item_spwaner.spwan_normal_item()
	
	animation_player.play("die")
	await animation_player.animation_finished
	
	queue_free()

#死亡状态期间的击退
func _on_dead_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_lifetime_timeout() -> void:
	pass
