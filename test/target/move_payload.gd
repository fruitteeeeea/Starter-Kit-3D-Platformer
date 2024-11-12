extends PathFollow3D

var player_near := false
var enemy_near := false

var max_move_speed := 0.05
var current_move_speed := 0.0
@onready var state_chart: StateChart = $StateChart

@onready var check_player: Area3D = $CheckPlayer
@onready var check_enemy: Area3D = $CheckEnemy

@onready var indicator_square_a: MeshInstance3D = $"indicator-square-a"
@export var alert_color : Material

@export var rigid_items_spwaner : Marker3D

func _physics_process(delta: float) -> void:
	progress_ratio += delta * current_move_speed


func _on_check_player_body_entered(body: Node3D) -> void:
	player_near = true
	state_chart.send_event("to_move")
	rigid_items_spwaner.timer.start()


func _on_check_player_body_exited(body: Node3D) -> void:
	player_near = false
	state_chart.send_event("to_idle")
	rigid_items_spwaner.timer.stop()


func _on_timer_timeout() -> void:
	if !player_near: #如果玩家不在的话 就跳过
		return
	
	check_enenmy()

#检查车子黄圈区域内是否有敌人
func check_enenmy():
	enemy_near = false #重置状态
	for body in check_enemy.get_overlapping_bodies():
		if body.has_method("state_enemy"):
			enemy_near = true
			do_alert()


func do_alert():
	indicator_square_a.set_surface_override_material(0, alert_color)
	pass

#处于移动状态的时候
func _on_move_state_physics_processing(delta: float) -> void:
	current_move_speed = lerpf(current_move_speed, max_move_speed, 0.1)

#处于闲置状态的时候
func _on_idle_state_physics_processing(delta: float) -> void:
	current_move_speed = lerpf(current_move_speed, 0.0, 0.1)
