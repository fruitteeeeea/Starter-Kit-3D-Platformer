extends Node

var is_crit_hit := false #是否为暴击
var is_guided_projectile := false #是否为跟踪子弹

var projecttile_arry := [] #子弹生成的时候添加到数组

##发射子弹 #子弹场景  #生成位置 #子弹方向 #子弹属性
func spwan_bullet(bullet01 : PackedScene, pos01 : Vector3, direction01 : Vector3, \
damge01 : float = 1.0, scale01 : float = 1.0, speed01 : float = 1.0):
	var bullet = bullet01.instantiate()
	
	bullet.damage = damge01
	bullet.scale01 *= scale01
	bullet.speed *= speed01
	
	get_tree().root.add_child(bullet)
	bullet.global_position = pos01
	bullet.direction = direction01

#发射炸弹
func spwan_bomb(weapon01 : Node3D, bullet_scene : PackedScene):
	weapon01.fire_sfx.play() #播放音效
	
	var bullet = bullet_scene.instantiate()
	if bullet.has_method("bullet") == false: #确认子弹确实是子弹
		return
	
	get_tree().root.add_child(bullet)
	bullet.position = weapon01.global_position #设定子弹位置
	
	var bullet_velocity_y = bullet.BombSpeedY
	var bullet_velocity_x = bullet.BombSpeedX
	
	if !weapon01.player.is_on_floor(): #处于空中时
		bullet_velocity_y = weapon01.throw_velocity_y * bullet.BombSpeedY
		bullet_velocity_x = weapon01.throw_velocity_x * bullet.BombSpeedX
		bullet.be_throw = true #标记炸弹处于投掷状态下丢出
		
	else: #处于地面时
		bullet_velocity_y = weapon01.normal_velocity_y * bullet.BombSpeedY
		bullet_velocity_x = weapon01.normal_velocity_x * bullet.BombSpeedX
	#应用弹道速度
	var direction = ((weapon01.marker_3d_2.global_position - weapon01.marker_3d.global_position)\
	 + Vector3(0, bullet_velocity_y, 0)).normalized() 
	bullet.apply_central_force(direction * bullet_velocity_x) #设计好弹道速度
	
	#设定好子弹初始旋转
	var random_offset = Vector3(randf_range(-45, 45), 1, randf_range(-45, 45))
	bullet.rotation += random_offset 
