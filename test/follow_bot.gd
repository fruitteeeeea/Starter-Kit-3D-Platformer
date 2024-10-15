extends Node3D

var player : CharacterBody3D
var follow_point : Marker3D

@onready var carrot_2: Node3D = $carrot2 #胡萝卜模型
@export var defult_posz := .311

@onready var detect_enemy_area: Area3D = $DetectEnemyArea #无人机检测范围
@onready var bot_firing_interval: Timer = $BotFiringInterval #无人机开火间隔
@onready var shoot_point: Marker3D = $ShootPoint #无人机开火位置
var tempo_array = [] #范围内敌人临时数组
@export var Bullet : PackedScene #子弹场景


var shoot_tween : Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player && follow_point:
		global_position = global_position.lerp(follow_point.global_position, .1) #后面是跟随速度

	rotation.y = lerp_angle(rotation.y, player.rotation_direction, delta * 25) #跟随人物转身速度

#开火间隔结束
func _on_bot_firing_interval_timeout() -> void:
	scan_enemy()

#对范围内敌人打击
func scan_enemy():
	#先清空临时数组
	tempo_array.clear()
	
	for body in detect_enemy_area.get_overlapping_bodies():
		if body.is_in_group("Enemy") && !body.floting:
			tempo_array.append(body) #获取所有范围内敌人到临时数组
	
	var nearest_enemy_distance := INF
	var target_pos : Vector3
	
	for enemy in tempo_array: #根据最近敌人距离发射导弹
		var distance = enemy.global_position.distance_to(global_position)
		if distance < nearest_enemy_distance:
			target_pos = enemy.global_position
	
	if target_pos: #如果存在目标打击点
		attack_enemy(target_pos)

#攻击最近的敌人
func attack_enemy(pos01 : Vector3):
	bot_shoot()
	var bullet = Bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = shoot_point.global_position
	var target_position = (pos01 - global_position).normalized() #记得归一化向量
	bullet.direction = target_position

#动画补间
func bot_shoot():
	if shoot_tween:
		shoot_tween.kill()
	
	shoot_tween = create_tween()
	shoot_tween.set_ease(Tween.EASE_OUT)
	shoot_tween.set_trans(Tween.TRANS_EXPO)
	shoot_tween.tween_property(carrot_2, "position:z", -defult_posz, .1)
	shoot_tween.set_trans(Tween.TRANS_ELASTIC)
	shoot_tween.tween_property(carrot_2, "position:z", defult_posz, .4)
