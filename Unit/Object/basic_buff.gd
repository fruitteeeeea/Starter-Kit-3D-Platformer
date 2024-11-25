extends Node
class_name Buff

signal buff_finish

enum BuffType {
	Player,
	Weapon,
	Enemy,
	Other
}

@export var buff_type := BuffType.Player  #buff的种类

@export var buff_property : String #具体属性
@export var buff_value : float #具体数值
@export var buff_duration : float #持续时间

@export var buff_icon : PackedScene #buff图标的UI节点

func _ready() -> void:
	await get_tree().create_timer(buff_duration).timeout
	buff_finish.emit(self) #持续时间结束后 推出
