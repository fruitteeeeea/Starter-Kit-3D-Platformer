extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var player : CharacterBody3D
var direction := Vector3.ZERO
var chase_speed := 1.2 #追逐玩家的速度

@export var knockback_recover := .2 #击退中的恢复速度
var knockback_direction : Vector3 #击退方向 相对于玩家的位置
var knockback_strength : float #攻击来源的击退强度

@onready var state_chart: StateChart = $StateChart
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("mouse_right"):
		#take_damage(Vector3(-1, 0, -1), 5)

#受到伤害
func take_damage(knockback_strength01 : float):
	$GPUParticles3D.emitting = true
	var player = get_tree().get_first_node_in_group("player")
	knockback_direction = (global_position - player.global_position).normalized()
	knockback_strength  = knockback_strength01
	state_chart.send_event("to_hurt")

#进入到击退状态
func _on_hurt_state_physics_processing(delta: float) -> void:
	velocity = knockback_direction * knockback_strength
	
	knockback_strength = lerpf(knockback_strength, 0, knockback_recover) #从击退中回复过来
	print(knockback_strength)
	
	if knockback_strength < 0.1:
		state_chart.send_event("to_idle")


func _on_chase_state_entered() -> void:
	animation_player.play("sprint")


func _on_hurt_state_entered() -> void:
	animation_player.play("fall")
