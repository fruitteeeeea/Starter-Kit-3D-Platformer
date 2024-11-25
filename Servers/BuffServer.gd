extends Node

#一项Buff应该包含这些东西：BuffID， Buff类型， Buff修改数据，Buff图标

var maximum_buff := 5 #最大buff数

var current_bufflist := [] #当前有的buff

var property_buff := { #具体属性用String表示
	"move_speed" : 0.0 #移动速度buff
}

var bufficon_info := {
	#buffID, BuffIcon
}

#添加buff
func add_buff(buff : PackedScene):
	if current_bufflist.size() == maximum_buff: #检查一下 如果达到最大buff数就强制推出最后一个buff
		remove_buff(current_bufflist[-1])
	
	var buff01 = buff.instantiate()
	add_child(buff01) #当成子节点实例化加入场景树
	
	current_bufflist.append(buff01) #添加buff
	#property_buff[buff01.buff_property] += buff01.buff_value #添加数值
	apply_buff(buff01, buff01.buff_value) #添加数值
	var icon = buff01.buff_icon.instantiate() #实例化图标节点
	bufficon_info[buff01] = icon #添加到图标字典
	Hud.buff_icon.add_child(icon) #添加图标节点
	buff01.buff_finish.connect(remove_buff) #链接buff结束信号

#修改 buff 数值
func apply_buff(buff01 : Buff, value01 : float):
	property_buff[buff01.buff_property] += buff01.buff_value
	#match buff01.BuffType: #按照 Buff 的种类对 Buff 进行应用 例如玩家状态 武器 敌人
	
	PlayerSatusServer.ModifyStatus[buff01.buff_property] += buff01.buff_value
	pass

#获取属性buff
func get_property_buff(property01) -> float:
	var final_value = 0
	for i in property_buff[property01]:
		final_value += i #对里面的每一个元素进行相加
	return property_buff[property01]

#移除buff
func remove_buff(buff01 : Buff):
	current_bufflist.erase(buff01) #移除icon
	#property_buff[buff01.buff_property] -= buff01.buff_value
	apply_buff(buff01, -buff01.buff_value) #恢复数值
	
	bufficon_info[buff01].queue_free() #移除图标
	bufficon_info.erase(buff01) #移除buff对应的icon
	buff01.queue_free() #移除节点
