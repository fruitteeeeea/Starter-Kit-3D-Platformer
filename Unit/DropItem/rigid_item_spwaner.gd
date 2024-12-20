extends Marker3D
#此处生成刚体掉落物 

@export var item_init_speed := 700

func spwan_rigid_item(item01 : PackedScene):
	var item = item01.instantiate()
	get_tree().root.add_child(item)
	item.position = global_position 
	
	var random_x = randf_range(-1.0, 1.0)
	var random_z = randf_range(-1.0, 1.0)
	
	var direction = Vector3(random_x, 1, random_z).normalized() #刚体方向
	item.apply_central_force(direction * item_init_speed)
	
	var random_offset = Vector3(randf_range(-45, 45), 1, randf_range(-45, 45))
	item.rotation += random_offset 
