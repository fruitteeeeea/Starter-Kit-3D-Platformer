extends Node3D
#任务目标：敌人生成点

@export var health := 10 #总的生命值

@export var damage_risist := 5 #伤害抗性
var current_hit := 0 #当前被攻击次数 如果攻击达到抗性 就进入保护阶段

@export var protect_timer := 3.0 #伤害计时器 

#标记自己是目标敌人生成器
func target_enemy_spwaner():
	pass

func get_hit(damage01 : int):
	health -= 1
	if health <= 0:
		die()

	current_hit += 1
	if current_hit >= damage_risist:
		current_hit = 0 #当前伤害归零
		

func do_protect():
	print("敌人生成点进入保护期")
	pass


func die():
	queue_free()
	pass
