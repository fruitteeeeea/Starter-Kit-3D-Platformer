extends PathFollow3D
class_name MovePayload

signal payload_move (payload01) #车子启动
signal payload_stop (payload01) #车子停下
signal payload_complete (payload01) #当到达终点时发出信号

var player_near := false
var enemy_near := false

var max_move_speed := 2.5 #玩家推动
var current_move_speed := 0.0
var reduce_speed := 0.1

var shoot_energy := 3.0 #射击推动
var current_energy := 0.0
var recover_speed := 1.0

var overall_speed := 0.0

@export var is_loop_payload := false #是否为无限循环的车子
var is_payload_complete := false #载具是否完成

@onready var state_chart: StateChart = $StateChart

@onready var check_player: Area3D = $CheckPlayer
@onready var check_enemy: Area3D = $CheckEnemy
@onready var timer: Timer = $Timer

@onready var indicator_square_a: MeshInstance3D = $"indicator-square-a"
@export var alert_color : Material

@onready var rigid_item_spwaner: Marker3D = $RigidItemSpwaner
@export var label : PackedScene

@export var RigidItem : PackedScene #车子生成物品
@export var RigidItems : Array[PackedScene] #列表
@onready var rigid_item_spwan_timer: Timer = $RigidItemSpwanTimer
@export var spwan_time := 2.0 #掉落时间
@export var spwan_time_min := 1.0
@export var spwan_time_max := 3.0

@onready var movement_indicator: Node3D = $MovementIndicator #移动指示器模型
@export var max_rotate_speed := 4.0
var current_rotate_speed := 0.0

#车子周遭位置
var surround_position := []
@onready var payload_surround_position: Node3D = $PayloadSurroundPosition
@onready var surround_pos_01: Marker3D = $PayloadSurroundPosition/SurroundPos01

var complete_debuff := [] #已完成的debuff挑战

func _ready() -> void:
	loop = is_loop_payload #根据车子的循环状况来决定 pathfollower3d 时候循环
	
	for marker in payload_surround_position.get_children():
		surround_position.append(marker)
	
	LevelTargetServer.add_payload(self)
	rigid_item_spwan_timer.wait_time = spwan_time

func _physics_process(delta: float) -> void:
	overall_speed = delta * current_move_speed + delta * current_energy #车子总的速度
	progress += overall_speed
	movement_indicator.rotation.y += delta * current_rotate_speed


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug"):
		#car_get_hit()

#获取车子附近位置的重要方法
func get_surrounding_position(distance_factor := 1.0) -> Vector3:
	if !surround_position:
		return Vector3.ZERO
	
	var target_pos = surround_position.pick_random().position * distance_factor
	return global_position + target_pos


func _on_check_player_body_entered(body: Node3D) -> void:
	player_near = true
	state_chart.send_event("to_move")
	rigid_item_spwan_timer.start()


func _on_check_player_body_exited(body: Node3D) -> void:
	player_near = false
	state_chart.send_event("to_idle")
	rigid_item_spwan_timer.stop()


func _on_timer_timeout() -> void:
	if !player_near: #如果玩家不在的话 就跳过
		return
	
	check_enenmy()

#检查车子黄圈区域内是否有敌人
func check_enenmy():
	for body in check_enemy.get_overlapping_bodies():
		if body.has_method("state_enemy"):
			enemy_near = true
			change_to_alert_state(true)
		
		else :
			enemy_near = false #重置状态
			change_to_alert_state(false)

#更改车子敌人检测区指示
func change_to_alert_state(state01 := false):
	if state01 == true:
		indicator_square_a.set_surface_override_material(0, alert_color)
	else :
		indicator_square_a.set_surface_override_material(0, null)


func _on_move_state_entered() -> void:
	$AnimationPlayer.play("moving")
	payload_move.emit(self)
	timer.start()
	indicator_square_a.show()

#处于移动状态的时候
func _on_move_state_physics_processing(delta: float) -> void:
	if enemy_near: #如果敌人在附近的话 就没 事儿了
		current_move_speed = lerpf(current_move_speed, 0.0, 0.1)
		return
	
	current_move_speed = lerpf(current_move_speed, max_move_speed, 0.1)
	current_rotate_speed = lerpf(current_rotate_speed, max_rotate_speed, 0.1)  #指示器旋转
	
	LevelTargetServer.current_payload[self] = progress_ratio

func _on_idle_state_entered() -> void:
	$AnimationPlayer.play("RESET")
	payload_stop.emit(self)
	timer.stop()
	indicator_square_a.hide()

#处于闲置状态的时候
func _on_idle_state_physics_processing(delta: float) -> void:
	current_move_speed = lerpf(current_move_speed, 0.0, 0.1) 
	current_rotate_speed = lerpf(current_rotate_speed, 0, 0.1) #指示器旋转
 

func car_get_hit():
	current_energy = shoot_energy 
	state_chart.send_event("to_activated")

#进入激活状态 车子会消耗能量自动前进
func _on_activated_state_entered() -> void:
	current_energy = shoot_energy 

#激活状态过程中减少能量
func _on_activated_state_physics_processing(delta: float) -> void:
	if enemy_near: #如果撞到敌人 当场停下
		current_energy = 0
	
	current_energy = move_toward(current_energy, 0, recover_speed * delta)
	
	if current_energy <= 0:
		state_chart.send_event("to_deactivated")

#进入非激活状态
func _on_deactivated_state_entered() -> void:
	if overall_speed > 0 :
		return
	
	payload_stop.emit(self)
	timer.stop()
	indicator_square_a.hide()


func _on_rigid_item_spwan_tiemr_timeout() -> void:
	rigid_item_spwan_timer.wait_time = randf_range(spwan_time_min, spwan_time_max)
	var item01 = RigidItems.pick_random()
	rigid_item_spwaner.spwan_rigid_item(item01)


func _on_notcomplete_state_physics_processing(delta: float) -> void:
	if progress_ratio == 1:
		state_chart.send_event("to_complete")


func _on_complete_state_entered() -> void:
	payload_complete.emit(self) #车子到达终点 发出信号
	$AnimationPlayer.play("complete")
	await $AnimationPlayer.animation_finished
	queue_free()
