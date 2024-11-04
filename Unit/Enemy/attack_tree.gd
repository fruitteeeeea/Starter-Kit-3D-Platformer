extends Node3D

signal enemy_dead(enemy : CharacterBody3D)

@export var Bullet : PackedScene #子弹场景
@export var do_shoot := true #是否进行射击

@export var show_posy := 0.0
@export var hide_posy := -2.5

@onready var shoot_point: Marker3D = $ShootPoint #子弹发射点
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var pine_fall_2: Node3D = $"pine-fall2" #树木的模型
@onready var floor_hole_2: Node3D = $"floor-hole2" #标识的模型
@onready var particles: CPUParticles3D = $Particles

@onready var state_chart: StateChart = $StateChart #状态机

var limited_posx : Vector2 #限制的水平活动范围
var limited_posz : Vector2 #限制的水平活动范围

var can_shoot := true #是否可以射击
var dected_player := false #是否检测到玩家

var level_manager : Node #定义关卡编辑器
var player : CharacterBody3D #玩家场景

func _ready() -> void:
	if get_parent().has_method("level_manager"):
		level_manager = get_parent()
		level_manager.battel_begain.connect(change_shoot_state.bind(true))
		level_manager.battel_finished.connect(change_shoot_state.bind(false))
	
	#设定好显示位置和隐藏位置
	show_posy = pine_fall_2.position.y
	hide_posy = pine_fall_2.position.y - 2.5

#时候开始射击
func change_shoot_state(state := false):
	do_shoot = state
	

#检测玩家进出
func _on_detect_player_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		dected_player = true

func _on_detect_player_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		dected_player = false

#生成时候的tween
func show_tween():
	particles.emitting = true
	floor_hole_2.scale = Vector3.ZERO #地板
	pine_fall_2.position.y = hide_posy
	
	var floor_tween = create_tween() #地板补间
	floor_tween.set_ease(Tween.EASE_OUT)
	floor_tween.set_trans(Tween.TRANS_ELASTIC)
	floor_tween.tween_property(floor_hole_2, "scale", Vector3.ONE, 0.5)
	await floor_tween.finished
	
	var tree_tween = create_tween() #树木补间
	tree_tween.set_ease(Tween.EASE_OUT)
	tree_tween.set_trans(Tween.TRANS_ELASTIC)
	tree_tween.tween_property(pine_fall_2, "position:y", show_posy, 1.5) #注意 global_position
	await tree_tween.finished
	particles.emitting = false
	state_chart.send_event("to_shoot")
	
#射击子弹的 tween
func shoot_tween():
	animation_player.play("alert") #警示标识动画
	await animation_player.animation_finished
	
	shoot_bullet()
	
	var current_scale = scale
	scale = current_scale * Vector3(1.8, .2, 1.8)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", current_scale, .8)
	await tween.finished
	
	animation_player.play("after_shoot") #警示标识动画
	await animation_player.animation_finished
	state_chart.send_event("to_idle")

#射击子弹
func shoot_bullet():
	player = get_tree().get_first_node_in_group("player")
	
	if Bullet && player:
		var bullet = Bullet.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = shoot_point.global_position
		var target_position = (player.global_position - global_position).normalized() #记得归一化向量
		bullet.direction = target_position

#模型收起来的动画
func hide_tween():
	var floor_target_scale = Vector3.ZERO
	
	var tree_tween = create_tween() #树木补间
	tree_tween.set_ease(Tween.EASE_OUT)
	tree_tween.set_trans(Tween.TRANS_EXPO)
	tree_tween.tween_property(pine_fall_2, "position:y", hide_posy, 0.8) #注意 global_position
	await tree_tween.finished

	var floor_tween = create_tween() #地板补间
	floor_tween.set_ease(Tween.EASE_OUT)
	floor_tween.set_trans(Tween.TRANS_EXPO)
	floor_tween.tween_property(floor_hole_2, "scale", floor_target_scale, 0.5)
	await floor_tween.finished
	
	if do_shoot:
			state_chart.send_event("to_respwan")


#重新定义下一个生成位置 #应用新坐标
func aplly_newlocate():
	limited_posx = level_manager.level_pos_h #检查关卡管理器是否存在限制范围
	limited_posz = level_manager.level_pos_v
	
	if limited_posx && limited_posz: #随机更改位置至限制范围内
		
		global_position.x = randf_range(limited_posx.x, limited_posx.y) 
		global_position.z = randf_range(limited_posz.x, limited_posz.y)

#进入 respwan 状态
func _on_respwan_state_entered() -> void:
	#await get_tree().create_timer(randf_range(1.0, 3.0)).timeout #闲置时间
	aplly_newlocate() #先分配新坐标
	show_tween()

#进入 shoot 状态
func _on_shoot_state_entered() -> void:
	#await get_tree().create_timer(randf_range(1.0, 3.0)).timeout #闲置时间
	shoot_tween()

#进入 idle 状态
func _on_idle_state_entered() -> void:
	#await get_tree().create_timer(randf_range(1.0, 3.0)).timeout #闲置时间
	hide_tween()
