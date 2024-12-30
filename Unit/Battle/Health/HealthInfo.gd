extends Resource
class_name HealthInfo

@export var max_health := 3.0 #最大生命值
var current_health := 0.0 #当前神秘值

@export var knockback_recover := .1 * 2 #击退中的恢复速度
var knockback_force := 1.0 #击退强度
var knockback_direction := Vector3.UP #击退强度

func take_damge(attack_01 : AttackInfo):
	current_health -= attack_01.damage
	knockback_force = attack_01.knockback_force
	knockback_direction = attack_01.knockback_direction
