extends Node3D

@export var Bullet : PackedScene #子弹场景

@onready var shoot_point: Marker3D = $ShootPoint #子弹发射点
@onready var timer: Timer = $Timer #射击间隔

var do_shoot := true #是否进行射击
var can_shoot := true #是否可以射击
var dected_player := false #是否检测到玩家

var player : CharacterBody3D #玩家场景

func _ready() -> void:
	born_tween()
	
	await get_tree().create_timer(randf_range(1.0, 5.0)).timeout
	timer.start()


#检测玩家进出
func _on_detect_player_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		dected_player = true

func _on_detect_player_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		dected_player = false


func _on_timer_timeout() -> void:
	if can_shoot:
		shoot_bullet()

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
	
