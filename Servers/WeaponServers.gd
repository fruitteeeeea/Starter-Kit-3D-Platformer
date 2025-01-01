extends Node
#管理武器相关的服务器

#====UI 相关====
signal weapon_fire (time : float) #向ui发送射击冷却信号
signal ui_secondary_weapon_fire_rate(time : float) #向ui发送射击冷却信号

#====武器具体参数====
var can_shoot := true

#白字属性
@export var BasicStatus := BasicWeaponStatus.new()
#应用战利品修改后的属性
@export var ModifyStatus := ModifyWeaponStatus.new()
#Buff 的加成属性
@export var BuffStatus := BuffWeaponStatus.new()

#====节点====
var main_weapon : Node
var second_weapon : Node
var player : CharacterBody3D

#获取具体数值
func WeaponInfo(value01 : String) -> float:
	var final_value = 0.0
	#final_value += weapon_info[value01] + modify_info.get(value01, 0) + buff_info.get(value01, 0)
	final_value += BasicStatus.status_info[value01] + ModifyStatus.status_info[value01] + BuffStatus.status_info[value01]
	return final_value

#==发射子弹 #子弹数量 #散射
func shoot_bullet(bullet01 : PackedScene, pos01 : Vector3, drection01 : Vector3):
	#收到玩家武器节点
	VisualServer.do_camerashake()
	
	for i in range(WeaponInfo("bullet_number")): #子弹数量
		var damage01 = WeaponInfo("bullet_damage")
		var scale01 = WeaponInfo("bullet_scale")
		var speed01 = WeaponInfo("bullet_speed") * \
		(1 + randf_range(-WeaponInfo("random_speed"), WeaponInfo("random_speed")))
		var direction02 = apply_horizontal_spread(drection01)
		
		ProjectileServer.spwan_bullet(bullet01, pos01, direction02, damage01, scale01, speed01)
		
		await get_tree().create_timer(WeaponInfo("bullet_interval")).timeout
	
	#这里处理武器冷却
	can_shoot = false
	var fire_colddown = max(WeaponInfo("fire_colddown"), 0.01) #限定最低冷却为 0.01
	weapon_fire.emit(fire_colddown) #发送新号
	await get_tree().create_timer(fire_colddown).timeout
	can_shoot = true

# 给定方向添加水平偏移
func apply_horizontal_spread(base_direction: Vector3) -> Vector3:
	var spread_angle = WeaponInfo("spread_angle")
	var angle_offset = randf_range(-spread_angle, spread_angle) #获取当前武器偏移参数
	angle_offset = deg_to_rad(angle_offset) # 将角度转换为弧度
	var rotated_direction = base_direction.rotated(Vector3.UP, angle_offset) # 在水平面（y 轴）上旋转方向向量
	return rotated_direction.normalized()

#==发射炸弹
func shoot_bomb(weapon01 : Node3D, bullet_scene : PackedScene):

	ProjectileServer.spwan_bomb(weapon01, bullet_scene) #使用射弹服务器发送子弹

#添加武器
func add_weapon(weapon01 : PackedScene):
	if !player:
		return

	for i in player.weapon.get_children():
		if i is Weapon:
			remove_weapon()

	var weapon = weapon01.instantiate()
	player.weapon.add_child(weapon)

#移除武器
func remove_weapon(): 
	if !player:
		return

	for i in player.weapon.get_children():
		if i is Weapon:
			i.queue_free()
