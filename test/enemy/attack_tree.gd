extends Node3D

@export var Bullet : PackedScene #子弹场景
@export var do_shoot := false #是否进行射击

@onready var shoot_point: Marker3D = $ShootPoint #子弹发射点
@onready var timer: Timer = $Timer #射击间隔
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	
	born_tween()
	
	await get_tree().create_timer(randf_range(1.0, 5.0)).timeout
	timer.start()


func change_shoot_state(state := false):
	do_shoot = state
	

#检测玩家进出
func _on_detect_player_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		dected_player = true

func _on_detect_player_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		dected_player = false


func _on_timer_timeout() -> void:
	limited_posx = level_manager.level_pos_h
	limited_posz = level_manager.level_pos_v
	
	if limited_posx && limited_posz: #随机更改位置
		global_position.x = randf_range(limited_posx.x, limited_posx.y)
		global_position.z = randf_range(limited_posz.x, limited_posz.y)
	
	#if can_shoot && do_shoot:
		#animation_player.play("alert")
		#await animation_player.animation_finished
		#shoot_bullet()
		#animation_player.play("after_shoot")

#生成时候的tween
func born_tween():
	var current_posy = global_position.y
	global_position.y = current_posy - 2.5
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "position:y", current_posy, 1.5)

func shoot_tween():
	var current_scale = scale
	scale = current_scale * Vector3(1.8, .2, 1.8)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", current_scale, .8)

func shoot_bullet():
	player = get_tree().get_first_node_in_group("player")
	
	shoot_tween()
	
	if Bullet && player:
		var bullet = Bullet.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = shoot_point.global_position
		var target_position = (player.global_position - global_position).normalized() #记得归一化向量
		bullet.direction = target_position
