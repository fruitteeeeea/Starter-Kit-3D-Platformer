extends RigidBody3D

var Player : CharacterBody3D

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

var chase_state := true

var direction := Vector3.ZERO #移动方向
var move_speed: float = 2.0 # 移动速度

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_tree().get_first_node_in_group("player")
	add_to_group("RigidEnemy")


func rigid_enmey():
	pass


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if !chase_state:
		return
	
	if Player:
		# 计算方向向量
		direction = (Player.global_position - global_position).normalized()
		# 计算施加的力
		var force = direction * move_speed
		
		look_at(Vector3(Player.global_position.x, global_position.y, Player.global_position.z), Vector3.UP)
		
	# 将力施加到刚体
	state.linear_velocity = direction * move_speed

#敌人被击退
func being_knockback(bullet01 : Node, knockback_force : float):
	gpu_particles_3d.emitting = true
	var recoil_direction = (global_position - Player.global_position).normalized()
	recoil_direction.y = 0 # 忽略 Y 轴，使后退只在 X 和 Z 方向上
	direction = recoil_direction.normalized() # 重新归一化
	move_speed = knockback_force
#
	#linear_velocity = recoil_direction * knockback_force # 设置后退速度
	#chase_state = false
	#
	#await get_tree().create_timer(10).timeout
	#chase_state = true
	pass
