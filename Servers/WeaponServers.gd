extends Node
#管理武器相关的服务器

#====UI 相关====
signal ui_main_weapon_fire_rate(time : float) #向ui发送射击冷却信号
signal ui_secondary_weapon_fire_rate(time : float) #向ui发送射击冷却信号

#====武器具体参数====
var spread_angle = 5.0 # 偏离的最大角度，以度数表示


#====节点====
var main_weapon : Node
var second_weapon : Node
var Player : CharacterBody3D

#==发射子弹
func shoot_bullet(projectile01 : PackedScene, spwan_nb : int, spwan_pos : Vector3, target_pos : Vector3, spare01 : float):
	#收到玩家武器节点
	
	ProjectileServer.spwan_bullet(projectile01, spwan_nb, spwan_pos, target_pos, spare01)

# 给定方向添加水平偏移
func apply_horizontal_spread(base_direction: Vector3) -> Vector3:
	# 生成随机偏移角度
	var angle_offset = randf_range(-spread_angle, spread_angle)
	
	# 将角度转换为弧度
	angle_offset = deg_to_rad(angle_offset)
	
	# 在水平面（y 轴）上旋转方向向量
	var rotated_direction = base_direction.rotated(Vector3.UP, angle_offset)
	
	return rotated_direction.normalized()

#==发射炸弹
func shoot_bomb(weapon01 : Node3D, bullet_scene : PackedScene):
	
	ProjectileServer.spwan_bomb(weapon01, bullet_scene) #使用射弹服务器发送子弹

#添加武器
func add_weapon(weapon01 : PackedScene):
	if !Player:
		return

	for i in Player.weapon.get_children():
		if i is Weapon:
			pass
		if i.has_method("weapon"):
			remove_weapon()

	var weapon = weapon01.instantiate()
	Player.weapon.add_child(weapon)

#移除武器
func remove_weapon(): 
	if !Player:
		return

	for i in Player.weapon.get_children():
		if i.has_method("weapon"):
			i.queue_free()
