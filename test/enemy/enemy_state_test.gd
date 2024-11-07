extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var player : CharacterBody3D
var direction := Vector3.ZERO
var chase_speed := 1.2 #追逐玩家的速度

var overall_strength : float #整体敌人强度

@export var knockback_recover := .2 #击退中的恢复速度
var knockback_direction : Vector3 #击退方向 相对于玩家的位置
var knockback_strength : float #攻击来源的击退强度

@onready var state_chart: StateChart = $StateChart
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#生命值相关
@export var health_component: Node

#视觉效果
@export var hurt_particle : GPUParticles3D #击中特效
@export var blood_trail : PackedScene #死亡血迹
@onready var blood_taril_pos: Marker3D = $BloodTarilPos

#击中闪烁 #身体部分
var body_parts = [ 
	$"character-skeleton/root/torso/head", $"character-skeleton/root/torso/arm-right",
	$"character-skeleton/root/torso/arm-left", $"character-skeleton/root/torso", 
	$"character-skeleton/root/leg-right", $"character-skeleton/root/leg-left"
]

@export var hit_flash_material : Material #受击时显示的材质

func _physics_process(delta: float) -> void:
	move_and_slide()


func state_enemy():
	pass

func _on_idle_state_physics_processing(delta: float) -> void:
	if is_on_floor():
		state_chart.send_event("to_chase")
	else:
		velocity += get_gravity() * delta


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
	$GPUParticles3D.emitting = true
	VisualServer.do_hit_flash(body_parts, hit_flash_material)
	SoundManager.play_sfx("EnemyHurtSFX", true)
	VisualServer.spwan_bloodtrail(blood_trail, blood_taril_pos.global_position, global_rotation) #生成血迹
	
	var player = get_tree().get_first_node_in_group("player")
	knockback_direction = (global_position - player.global_position).normalized()
	
	#在这里结算生命值
	if health_component:
		health_component.damage(damge)
	
	knockback_strength  = knockback_strength01
	state_chart.send_event("to_hurt")


#进入到击退状态
func _on_hurt_state_physics_processing(delta: float) -> void:
	velocity = knockback_direction * knockback_strength
	
	knockback_strength = lerpf(knockback_strength, 0, knockback_recover) #从击退中回复过来
	
	if knockback_strength < 0.1:
		state_chart.send_event("to_idle")


func _on_chase_state_entered() -> void:
	animation_player.play("sprint")


func _on_hurt_state_entered() -> void:
	if health_component.health <= 0: #如果没血了 直接进入死亡状态
		state_chart.send_event("to_hurt")
	else:
		animation_player.play("fall")
