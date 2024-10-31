extends Node

var spwan_pos : Vector3 #发射位置
var target_pos : Vector3 #目标位置

var is_crit_hit := false #是否为暴击
var is_guided_projectile := false #是否为跟踪子弹

var projecttile_arry := [] #子弹生成的时候添加到数组

#发射子弹 #子弹场景 #生成数量 #生成位置 # 目标位置 
func spwan_projectile(projectile01 : PackedScene, spwan_nb : int, spwan_pos : Vector3, target_pos : Vector3 ): 
	for i in spwan_nb:
		var projectile = projectile01.instantiate()
	pass

#发射炸弹
func spwan_bomb():
	pass
