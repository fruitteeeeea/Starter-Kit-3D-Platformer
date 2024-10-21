extends Marker3D

@export var DamageNumber : PackedScene

func spwan_damage_number(attack_damage := 0.0):
	var random_pos = randf_range(-1, 1)
	
	var damage_number = DamageNumber.instantiate()
	get_tree().root.call_deferred("add_child", damage_number)
	await damage_number.tree_entered
	#damage_number.global_position = global_position + Vector3(random_pos, 0, random_pos)
	damage_number.global_position = global_position 
	damage_number.text = str(attack_damage)
