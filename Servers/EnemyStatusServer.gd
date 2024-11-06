extends Node

#当前场景生成器配置
var enemy_spwaner := [] #所有生成器加入到一个数组中
var enemy_in_scene := [] #当前场景存在的敌人

#添加敌人生成器
func add_enemy_spwaner(spwaner01 : PackedScene):
	var spwaner = spwaner01 #实例化生成器
	get_tree().root.add_child(spwaner) #添加到场景树中


#删除敌人生成器
func remove_enemy_spwaner():
	pass


func add_enemy(spwaner01 : Marker3D): #选择要生成怪物的敌人
	if !enemy_spwaner: #如果没有 spwaner 的话 那就没事儿了
		return
	
	var current_spwaner = spwaner01 #为目标spwaner 生成敌人
	var current_enemy = current_spwaner.enemy_scene #选择该敌人 
	
	var enemy = current_enemy.instantiate() #生成敌人
	get_tree().root.add_child(enemy)
	
	enemy.overall_strength = current_spwaner.enemy_power #设置怪物强度
	
	enemy.global_position = current_spwaner.global_position + \
	Vector3(randf_range(-current_spwaner.rand_range, current_spwaner.rand_range), \
	0, randf_range(-current_spwaner.rand_range, current_spwaner.rand_range)) #随机位置

	#理论上在地图范围内选择随机位置是生成敌人会非常好


func remove_enemy(enemy01 : CharacterBody3D):
	pass
