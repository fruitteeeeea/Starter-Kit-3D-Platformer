extends Node3D
class_name PayloadArms
#载具的武装

enum WeaponType {
	BulletType, #子弹武器
	BombType, #炸弹武器
	MeleeType #近战武器
}
@export var weapon_type := WeaponType.BulletType #武器种类
@export var is_guidance := false #自动对准敌人

#子弹武器
@export var Bullet : PackedScene #子弹的实例
@export var bullet_number := 10 #子弹数量

#炸弹武器
@export var Bomb : PackedScene #炸弹实例
@export var bomb_number := 3 #子弹数量

#近战武器
@onready var payload_arms_melee: Node3D = $PayloadArmsMelee

#计时器相关
@export var fire_colddown := 5.0 #开火冷却
@onready var fire_timer: Timer = $FireTimer
@export var timer_offset := 0.5 #随机时间误差

var parent_payload : MovePayload

func _ready() -> void:
	fire_timer.start(fire_colddown)
	fire_timer.paused = true
	if get_parent().get_parent() is MovePayload:
		parent_payload = get_parent().get_parent()
		parent_payload.payload_move.connect(_arms_state_actived.bind(true))
		parent_payload.payload_stop.connect(_arms_state_actived.bind(false))

#计时器结束
func _on_fire_timer_timeout() -> void:
	fire_timer.wait_time = fire_colddown + randf_range(-timer_offset, timer_offset) #冷却时间偏移
	payload_arms_attack()

#按照要求攻击
func payload_arms_attack():
	match weapon_type:
		WeaponType.BulletType:
			for i in range(bullet_number):
				do_fire()
		WeaponType.BombType:
			for i in range(bomb_number):
				do_throw()
				await get_tree().create_timer(randf_range(.1, .2)).timeout
		WeaponType.MeleeType:
			do_melee()

#动态更改车子武装状态
func _arms_state_actived(payload01 : MovePayload, state := true):
	if state == true:
		fire_timer.paused = false
	else:
		fire_timer.paused = true


func get_random_horizontal_direction() -> Vector3:
	# 生成一个 0 到 360 度之间的随机角度
	var random_angle_degrees = randf_range(0, 360)
	# 将角度转换为弧度
	var random_angle_radians = deg_to_rad(random_angle_degrees)
	# 使用正弦和余弦计算 X 和 Z 分量，Y 为 0（水平方向）
	var direction = Vector3(cos(random_angle_radians), 0, sin(random_angle_radians))
	return direction.normalized()  # 确保方向向量归一化

#子弹武器就会
func do_fire():
	var random_direction = get_random_horizontal_direction()
	var bullet = Bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = global_position 
	bullet.direction = random_direction

#炸弹武器就会
func do_throw():
	var bomb = Bomb.instantiate()
	bomb.position = global_position
	get_tree().root.add_child(bomb)
	bomb.rotation.y = randf() * TAU

#近战武器就会
func do_melee():
	payload_arms_melee.rotation.y = randf() * TAU #围绕 y 轴随机旋转
	payload_arms_melee.do_stab() 
