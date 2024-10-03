extends Node

@export var max_health := 3.0 #最大生命值
var health := 0.0 #当前生命值

func _ready() -> void:
	health = max_health

func damage(attack_damage := 1.0, knockback_force := 100, attack_posiiton := Vector3.ZERO):
	health -= attack_damage
