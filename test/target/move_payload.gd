extends PathFollow3D

signal payload_move #车子启动
signal payload_stop #车子停下
signal payload_complete #当到达终点时发出信号

var player_near := false
var enemy_near := false

var max_move_speed := 0.05
var current_move_speed := 0.0
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

func _ready() -> void:
	LevelTargetServer.add_payload(self)
	rigid_item_spwan_timer.wait_time = spwan_time

func _physics_process(delta: float) -> void:
	progress_ratio += delta * current_move_speed


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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		change_to_alert_state(true)
	if event.is_action_released("mouse_right"):
		change_to_alert_state()

#更改车子敌人检测区指示
func change_to_alert_state(state01 := false):
	if state01 == true:
		indicator_square_a.set_surface_override_material(0, alert_color)
	else :
		indicator_square_a.set_surface_override_material(0, null)


func _on_move_state_entered() -> void:
	payload_move.emit()
	timer.start()
	indicator_square_a.show()

#处于移动状态的时候
func _on_move_state_physics_processing(delta: float) -> void:
	if enemy_near: #如果敌人在附近的话 就没事儿了
		current_move_speed = lerpf(current_move_speed, 0.0, 0.1)
		return
	
	current_move_speed = lerpf(current_move_speed, max_move_speed, 0.1)
	LevelTargetServer.current_payload[self] = progress_ratio

func _on_idle_state_entered() -> void:
	payload_stop.emit()
	timer.stop()
	indicator_square_a.hide()

#处于闲置状态的时候
func _on_idle_state_physics_processing(delta: float) -> void:
	current_move_speed = lerpf(current_move_speed, 0.0, 0.1)


func _on_rigid_item_spwan_tiemr_timeout() -> void:
	rigid_item_spwan_timer.wait_time = randf_range(spwan_time_min, spwan_time_max)
	var item01 = RigidItems.pick_random()
	rigid_item_spwaner.spwan_rigid_item(item01)
