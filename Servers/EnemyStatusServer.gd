extends Node

#当前场景生成器配置
var enemy_spwaner := [] #所有生成器加入到一个数组中
var enemy_in_scene := [] #当前场景存在的敌人 #总的敌人数量

var spwaner_info := {
	#生成节点 #计时器 #敌人类型 #最大敌人数 #当前敌人数 
}

var modify_info := {
}

var buff_info := {
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
	enemy.enemy_dead.connect(remove_enemy) #链接消除敌人信号
	enemy.enemy_dead.connect(spwaner01.remove_enemy) #生成节点链接消除敌人信号
	
	enemy.overall_strength = spwaner01.enemy_power #设置怪物强度
	
	enemy.global_position = spwaner01.global_position + \
	Vector3(randf_range(-spwaner01.rand_range, spwaner01.rand_range), \
	0, randf_range(-spwaner01.rand_range, spwaner01.rand_range)) #随机位置
	#只会在水平方向上进行位置随机
	#理论上在地图范围内选择随机位置是生成敌人会非常好

#生成敌人方法 #敌人内心 敌人强度 敌人 位置
func _add_enemy(spwaner01 : EnemySpawner, enemy01 : PackedScene, enemy_strength : float = 1.0, enemy_pos01 : Vector3 = Vector3.ZERO):
	var enemy = enemy01.instantiate()
	get_tree().root.add_child(enemy)
	
	enemy.spwaner = spwaner01
	enemy_in_scene.append(enemy) #添加总敌人列表中
	EnemySpwanerServer.spwaner_info[spwaner01].append(enemy)
	enemy.enemy_dead.connect(remove_enemy) #链接消除敌人信号
	enemy.scale = Vector3.ONE * randf_range(.8, 1.5)
	
	enemy.global_position = enemy_pos01 #随机位置


func remove_enemy(enemy01 : CharacterBody3D):
	if enemy01.spwaner: #如果有生成器的话 就在生成器字典删掉自己
		EnemySpwanerServer.spwaner_info[enemy01.spwaner].erase(enemy01) #从生成节点信息中删除
	
	enemy_in_scene.erase(enemy01)

#删除离车子远的敌人
func remove_enemy_from_distance():
	if !LevelTargetServer.current_actived_payloads: #有没有车子 没车子就算了
		return
	pass

#删除敌人生成器
func remove_enemy_spwaner(spwaner01 : Marker3D):
	enemy_spwaner.erase(spwaner01) #从数组中移除生成器
	spwaner01.queue_free() #释放节点
