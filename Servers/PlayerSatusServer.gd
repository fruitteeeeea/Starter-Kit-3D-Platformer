sextends Node

#白字属性
@export var BaiscSatus := {
	"attack_damage" : 10.0,
	"attack_speed" : 1.2, 
	"crithit_rate" : 0.2,
	"crithit_damage" : 1.5
}

@export var BasicStatus := {
	"move_speed" : 100, #移动速度
	"jump_hight" : 100, #跳跃高度
	"multi_jump" : 1 #多段跳跃
}

#修改来源 修改值 修改量
func set_player_status(source : Node, val : int):
	
	#需要打印修改来源 修改量 修改前的值 修改后的值
	pass


func get_player_status(status: String):
	pass
