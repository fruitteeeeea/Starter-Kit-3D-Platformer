extends CharacterBody3D
#闲置
#挑选车子/玩家周边范围内的随机位置 #不超过自身与目标地点夹角的180度
#移动到目标位置
#朝着玩家发射子弹

var is_hurt := false #受伤标记
var is_dying := false #死亡标记

var direction := Vector3.ZERO
var move_speed := 3.8 #追逐玩家的速度

var target_pos : Vector3

@onready var state_chart: StateChart = $StateChart
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var Bullet : PackedScene #子弹场景

func state_enemy():
	pass

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	if !is_on_floor():
		velocity.y -= 25 * delta
	move_and_slide()

#执行攻击 #朝着玩家发射子弹
func attack():
	var player = get_tree().get_first_node_in_group("player")
	var pos01 = $EnemyAttack/Marker3D.global_position
	var target_direction = (player.global_position - global_position).normalized() #获取发射方向
	ProjectileServer.spwan_bullet(Bullet, pos01, target_direction, 1.0, 1.0, .1) #速度是普通子弹的一般


#移动到目标地点
func move_to_target():
	var player = get_tree().get_first_node_in_group("player")
	
	if !player: #如果没有玩家 则返回闲置状态
		state_chart.send_event("to_idle")
	
	direction = (player.global_position - global_position).normalized() #获取玩家方向
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP) #朝向玩家
	velocity = direction * move_speed #追逐方向和追逐速度
	
	if global_position.distance_to(player.global_position) < 6.0: #到达目标地址
		state_chart.send_event("to_attack")


func _on_idle_state_physics_processing(delta: float) -> void:
	if is_hurt or is_dying: #如果受伤或者死亡的话 直接跳过
		return
	
	if is_on_floor():
		state_chart.send_event("to_move")


func _on_move_state_entered() -> void:
	animation_player.play("walk")
	

func _on_move_state_physics_processing(delta: float) -> void:
	if is_hurt or is_dying:
		return
	
	if is_on_floor():
		move_to_target()
	else :
		state_chart.send_event("to_idle")


func _on_attack_state_entered() -> void:
	animation_player.play("idle") #攻击前摇
	await get_tree().create_timer(randf_range(.1, .15)).timeout
	
	attack()
	animation_player.play("attack-melee-left")
	await animation_player.animation_finished
	state_chart.send_event("to_idle")


func _on_attack_state_physics_processing(delta: float) -> void:
	if is_hurt or is_dying:
		return
	
	velocity = Vector3.ZERO #进行攻击的时候 停止移动
