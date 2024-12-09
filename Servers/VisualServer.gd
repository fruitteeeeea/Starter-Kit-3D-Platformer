extends Node


#生成受击粒子 #粒子实例 #生成位置
func spwan_hurt_particle(particle01 : PackedScene, pos01 : Vector3):
	var hurt_particle = particle01.instantiate()
	get_tree().root.add_child(hurt_particle)
	hurt_particle.global_position = pos01
	pass

#生成血迹 #血迹场景 #血迹位置 #血迹旋转
func spwan_bloodtrail(blood01 : PackedScene, pos01 : Vector3, rotate01 : Vector3, change01 := .3):
	if randf_range(0.0, 1.0) > change01:
		return
	
	var blood_trail = blood01.instantiate()
	get_tree().root.add_child(blood_trail)
	blood_trail.global_position = pos01 #设置位置
	blood_trail.global_rotation = rotate01 #设置方向
	blood_trail.rotation_degrees.x = 90

#打击停顿
func hit_stop_medium(scale01 := .85, time01 := 0.05):
	Engine.time_scale = scale01
	await get_tree().create_timer(time01, true, false, true).timeout
	Engine.time_scale = 1

#生成飘字
func spwan_floating_text(text01 : PackedScene, pos01 : Vector3, damage01 : float):
	var text = text01.instantiate()
	get_tree().root.add_child(text)
	text.global_position = pos01 + Vector3.ONE * randf_range(-0.2, 0.2) #随机位置偏移
	text.floating_tween(damage01)

#屏幕抖动
func do_camerashake(shake_factor := 0.5):
	var camera = get_viewport().get_camera_3d()
	if camera.has_method("add_trauma"):
		camera.add_trauma(shake_factor)

#指定受击反馈物体 闪红 #传递身体组件 #传递闪红材质
func do_hit_flash(body_parts01 : Array, hit_flash_material : Material):
	for parts in body_parts01:
		hit_flash(parts, hit_flash_material)

#具体操作 闪红
func hit_flash(part01 : MeshInstance3D, hit_flash_material):
	if is_instance_valid(part01):
		part01.set_surface_override_material(0, hit_flash_material)
	await get_tree().create_timer(.25).timeout
	if is_instance_valid(part01):
		part01.set_surface_override_material(0, null)
 
