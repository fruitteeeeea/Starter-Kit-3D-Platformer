extends Node



#白字属性
@export var BasicStatus := BasicPlayerStatus.new()
#应用战利品修改后的属性
@export var ModifyStatus := ModifyPlayerStatus.new()
#Buff 的加成属性
@export var BuffStatus := BuffPlayerStatus.new()

#修改来源 修改值 修改量
func set_player_status(source : Node, val : int):
	#需要打印修改来源 修改量 修改前的值 修改后的值
	pass


func get_player_status(status01: String) -> float: #综合三个数值之后得到的
	var final_value = 0
	final_value = BasicStatus.status_info[status01] + ModifyStatus.status_info[status01] + BuffStatus.status_info[status01]
	return final_value

#新的游戏会重置玩家加成状况
func reset_modify_status():
	ModifyStatus = ModifyPlayerStatus.new() #重置加成效果
