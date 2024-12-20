extends Node

var enemy_in_scene := [] #当前场景存在的敌人 #总的敌人数量

#生成敌人方法 #敌人内心 敌人强度 敌人 位置
func add_enemy(spwaner01 : EnemySpawner, enemy01 : PackedScene, enemy_strength : float = 1.0, enemy_pos01 : Vector3 = Vector3.ZERO):
	var enemy = enemy01.instantiate()
	get_tree().current_scene.spwan_object.add_child(enemy) #添加到当前关卡生成物存储节点
	
	enemy.spwaner = spwaner01
	enemy_in_scene.append(enemy) #添加总敌人列表中
	EnemySpwanerServer.spwaner_info[spwaner01].append(enemy)
	enemy.enemy_dead.connect(remove_enemy) #链接消除敌人信号
	enemy.scale = Vector3.ONE * randf_range(.8, 1.5)
	#TODO 设置敌人强度overall_strength
	
	enemy.global_position = enemy_pos01 #随机位置

#删除敌人
func remove_enemy(enemy01 : CharacterBody3D):
	if enemy01.spwaner: #如果有生成器的话 就在生成器字典删掉自己
		EnemySpwanerServer.spwaner_info[enemy01.spwaner].erase(enemy01) #从生成节点信息中删除
	
	enemy_in_scene.erase(enemy01)
