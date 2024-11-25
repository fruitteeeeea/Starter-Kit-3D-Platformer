extends Node


@export var BaiscSatus := { #武器数据？
	"attack_damage" : 10.0,
	"attack_speed" : 1.2, 
	"crithit_rate" : 0.2,
	"crithit_damage" : 1.5
}

#白字属性
@export var BasicStatus := {
	"move_speed" : 100, #移动速度
	"jump_hight" : 100, #跳跃高度
	"multi_jump" : 1 #多段跳跃
}

@export var ModifyStatus := { #应用战利品修改后的属性
	"move_speed" : 50.0 #移动速度
}

@export var BuffStatus := { #Buff 的加成属性
	"move_speed" : 50.0 #移动速度
}

#修改来源 修改值 修改量
func set_player_status(source : Node, val : int):
	#需要打印修改来源 修改量 修改前的值 修改后的值
	pass


func get_player_status(status01: String) -> float: #综合三个数值之后得到的
	var final_value = 0
	final_value = BaiscSatus[status01] + ModifyStatus[status01] + BuffStatus[status01]
	return final_value
