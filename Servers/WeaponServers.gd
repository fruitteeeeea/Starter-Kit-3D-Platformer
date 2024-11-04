extends Node

#====UI 相关====
signal ui_main_weapon_fire_rate(time : float) #向ui发送射击冷却信号
signal ui_secondary_weapon_fire_rate(time : float) #向ui发送射击冷却信号

#管理武器相关的服务器

var main_weapon : Node
var second_weapon : Node

var Player : CharacterBody3D

#添加武器
func add_weapon(weapon01 : PackedScene):
	if Player:
		for i in Player.weapon.get_children():
			if i.has_method("weapon"):
				remove_weapon()
		
		var weapon = weapon01.instantiate()
		Player.weapon.add_child(weapon)

#移除武器
func remove_weapon(): 
	if Player:
		for i in Player.weapon.get_children():
			if i.has_method("weapon"):
				i.queue_free()


#发射子弹
func shoot_bullet(projectile01 : PackedScene, spwan_nb : int, spwan_pos : Vector3, target_pos : Vector3, spare01 : float):
	#收到玩家武器节点
	
	ProjectileServer.spwan_bullet(projectile01, spwan_nb, spwan_pos, target_pos, spare01)

#发射炸弹
func shoot_bomb(weapon01 : Node3D, bullet_scene : PackedScene):
	
	
	ProjectileServer.spwan_bomb(weapon01, bullet_scene) #使用射弹服务器发送子弹
 
func hit_stop_short():
	Engine.time_scale = 0.8
	await get_tree().create_timer(.05, true, false, true).timeout
	Engine.time_scale = 1


func add_camera_shake(factor01 := .1):
	#应用相机抖动
	var camera = get_viewport().get_camera_3d()
	if camera.has_method("add_trauma"):
		camera.add_trauma(factor01)
