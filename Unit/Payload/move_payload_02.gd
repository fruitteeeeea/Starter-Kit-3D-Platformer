extends MovePayload

var player_enter := false
var enemy_enter := false

@onready var particles_trail: CPUParticles3D = $ParticlesTrail
@onready var state_chart: StateChart = $StateChart

@onready var rigid_item_spwaner: Marker3D = $RigidItemSpwaner
@onready var rigid_item_timer: Timer = $RigidItemSpwaner/RigidItemTimer

@onready var anchor: Node3D = $Anchor
@onready var arms: Node3D = $Arms #存储载具武装的节点

func _ready() -> void:
	loop = is_loop_payload 
	PayloadServer.add_payload(self)

func _physics_process(delta: float) -> void:
	overall_speed = delta * current_move_speed + delta * current_energy #车子总的速度
	progress += overall_speed


func _on_not_moving_state_entered() -> void:
	payload_stop.emit(self)
	$Vechice/VechiceAnimationPlayer.play("RESET")


func _on_not_moving_state_physics_processing(delta: float) -> void:
	if player_enter == true and enemy_enter == false:
		state_chart.send_event("to_moving")
	
	current_move_speed = lerpf(current_move_speed, 0.0, 0.1) 


func _on_moving_state_entered() -> void:
	payload_move.emit(self)
	$Vechice/VechiceAnimationPlayer.play("moving")


func _on_moving_state_physics_processing(delta: float) -> void:
	if enemy_enter == true or player_enter == false:
		state_chart.send_event("to_not_moving")
	
	if progress_ratio == 1:
		state_chart.send_event("to_complete")
	
	current_move_speed = lerpf(current_move_speed, max_move_speed, 0.1)
	PayloadServer.current_payload[self] = progress_ratio


func _on_rigid_item_timer_timeout() -> void:
	if player_enter == true:
		rigid_item_timer.wait_time = 1 + randf_range(-.5, .5) #随机化生成时间
		var item01 = RigidItems.pick_random()
		rigid_item_spwaner.spwan_rigid_item(item01)


func _on_detect_player_body_entered(body: Node3D) -> void:
	player_enter = true


func _on_detect_player_body_exited(body: Node3D) -> void:
	player_enter = false


func _on_detect_enemy_body_entered(body: Node3D) -> void:
	enemy_enter = true


func _on_detect_enemy_body_exited(body: Node3D) -> void:
	enemy_enter = false


func _on_complete_state_entered() -> void:
	payload_complete.emit(self) #车子到达终点 发出信号
	$Vechice/VechiceAnimationPlayer.play("complete")
	$AuraEffect.emitting = true
	$AuraEffect2.emitting = true
	SoundManager.play_sfx("PayloadCompleteSFX")
	await $Vechice/VechiceAnimationPlayer.animation_finished
	Hud.level_massage.show_massage("已完成载具运送", "前往下一个目标或离开关卡")
	queue_free()
