extends Node

#当前场景生成器配置
var enemy_spwaner := [] #所有生成器加入到一个数组中

var spwaner_info := {
	#生成节点 #计时器 #敌人类型 #最大敌人数 #当前敌人数 
	#生成节点 当前敌人队列
	
}

#添加敌人生成器
func add_enemy_spwaner(spwaner01 : PackedScene):
	var spwaner = spwaner01 #实例化生成器
	get_tree().root.add_child(spwaner) #添加到场景树中
	
	enemy_spwaner.append(spwaner)
	spwaner_info[spwaner01] = [] #加载敌人队列

#激活生成器
func activate_spwaner(spwaner01 : EnemySpawner):
	if spwaner_info[spwaner01].size() >= spwaner01.max_enemy_nb: #限制生成最大数量敌人
		return 
	
	#应该根据生成器的种类来决定如何生成敌人 （跟随生成器 普通生成器
	#计算出位置
	var enemy01 = spwaner01.enemy_scene
	var strength01 = spwaner01.enemy_strength
	
	var pos01 = PayloadServer.GetPayloadAroundPos(spwaner01.spwan_range, spwaner01.spwan_angle, spwaner01.angle_bais)\
	 + spwaner01.spwan_high #由载具服务器选定位置
	if PayloadServer.GetPayloadAroundPos(5, 0.0, 0.0) == Vector3.ZERO: #防止未找到当前活跃载具
		return

	EnemyStatusServer._add_enemy(spwaner01, enemy01, strength01, pos01)

#删除敌人生成器
func remove_enemy_spwaner(spwaner01 : Marker3D):
	enemy_spwaner.erase(spwaner01) #从数组中移除生成器
	spwaner_info.erase(spwaner01) #从字典中移除生成器
	spwaner01.queue_free() #释放节点
