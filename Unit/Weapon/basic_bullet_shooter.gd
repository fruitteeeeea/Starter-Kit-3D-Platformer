extends Weapon

@export var Bullet : PackedScene #子弹节点

@onready var marker_3d: Marker3D = $Marker3D #发射子弹位置
@onready var marker_3d_2: Marker3D = $Marker3D2

@onready var fire_sfx: AudioStreamPlayer = $FireSFX #音效节点

@export var weapon_status : BasicWeaponStatus #武器的状态数据

@export var BulletShell : PackedScene #弹壳场景
@export var spwan_shell_change := .66
@onready var rigid_item_spwaner: Marker3D = $RigidItemSpwaner

#确认玩家
var player : CharacterBody3D

func _ready() -> void:
	WeaponServers.BasicStatus = weapon_status #更新一下数据
	
	await get_tree().create_timer(.01).timeout
	player = get_tree().get_first_node_in_group("player") #获取玩家

func do_fire():
	if !WeaponServers.can_shoot:
		return

	super.do_fire() #先执行父级方法
	shoot_bullet()

#射击子弹 #后期使用 ProjectileServer
func shoot_bullet():
	fire_sfx.play()
	add_bullet_shell() #添加弹壳
	
	var pos01 = marker_3d_2.global_position
	var direction01 = (marker_3d_2.global_position - marker_3d.global_position).normalized()
	WeaponServers.shoot_bullet(Bullet, pos01, direction01)

#生成弹壳
func add_bullet_shell():
	if BulletShell == null:
		return
	
	for i in range(WeaponServers.WeaponInfo("bullet_number")): #根据子弹数量判定是否爆香蕉
		var random_nb = randf_range(0.0, 1.0)
		if random_nb > spwan_shell_change:
			return #生成弹壳几率
		
		rigid_item_spwaner.spwan_rigid_item(BulletShell)
