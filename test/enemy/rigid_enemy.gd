extends RigidBody3D

var Player : CharacterBody3D
var move_speed: float = 3.0 # 移动速度


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if Player:
		# 计算方向向量
		var direction = (Player.global_position - global_position).normalized()
		# 计算施加的力
		var force = direction * move_speed
		# 将力施加到刚体
		state.linear_velocity = direction * move_speed
