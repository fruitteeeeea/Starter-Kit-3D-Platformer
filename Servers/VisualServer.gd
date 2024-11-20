extends Node


#生成受击粒子 #粒子实例 #生成位置
func spwan_hurt_particle(particle01 : PackedScene, pos01 : Vector3):
	var hurt_particle = particle01.instantiate()
	get_tree().root.add_child(hurt_particle)
	hurt_particle.global_position = pos01
	pass

#生成伤害飘动文字
func damage_float_nb():
	pass

#生成血迹 #血迹场景 #血迹位置 #血迹旋转
func spwan_bloodtrail(blood01 : PackedScene, pos01 : Vector3, rotate01 : Vector3):
	var blood_trail = blood01.instantiate()
	get_tree().root.add_child(blood_trail)
	blood_trail.global_position = pos01 #设置位置
	blood_trail.global_rotation = rotate01 #设置方向
	blood_trail.rotation_degrees.x = 90

func hit_stop():
	pass

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
 
