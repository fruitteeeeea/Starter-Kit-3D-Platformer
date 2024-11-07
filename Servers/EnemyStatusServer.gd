extends Node

#当前场景生成器配置
var enemy_spwaner := [] #所有生成器加入到一个数组中
var enemy_in_scene := [] #当前场景存在的敌人 #总的敌人数量

var spwaner_info := {
	#生成节点 #计时器 #敌人类型 #最大敌人数 #当前敌人数 
}


#添加敌人生成器
func add_enemy_spwaner(spwaner01 : PackedScene):
	var spwaner = spwaner01 #实例化生成器
	get_tree().root.add_child(spwaner) #添加到场景树中
	spwaner_info[spwaner01] = []

func add_enemy(spwaner01 : Marker3D): #选择要生成怪物的敌人
	if !enemy_spwaner: #如果没有 spwaner 的话 那就没事儿了
		return
	
	var Enemy = spwaner01.enemy_scene #选择该敌人 
	
	var enemy = Enemy.instantiate() #生成敌人
	get_tree().root.add_child(enemy)
	
	enemy_in_scene.append(enemy) #添加总敌人列表中
	spwaner01.current_enemy_in_scene.append(enemy) #添加到敌人列表中
	
	enemy.overall_strength = spwaner01.enemy_power #设置怪物强度
	
	enemy.global_position = spwaner01.global_position + \
	Vector3(randf_range(-spwaner01.rand_range, spwaner01.rand_range), \
	0, randf_range(-spwaner01.rand_range, spwaner01.rand_range)) #随机位置
	#只会在水平方向上进行位置随机
	#理论上在地图范围内选择随机位置是生成敌人会非常好


func remove_enemy(enemy01 : CharacterBody3D):
	pass


#删除敌人生成器
func remove_enemy_spwaner(spwaner01 : Marker3D):
	enemy_spwaner.erase(spwaner01) #从数组中移除生成器
	spwaner01.queue_free() #释放节点
	pass
