extends AttackInfo
class_name PlayerAttackInfo

func get_attack_damage():
	damage += WeaponServers.modify_info["bullet_damage"] + WeaponServers.buff_info["bullet_damage"]
	return damage


func get_attack_knockback_force():
	return knockback_force


func get_attack_knockback_direction(selfpos : Vector3, targpos : Vector3):
	knockback_direction = (selfpos - targpos).normalized()
	return damage
