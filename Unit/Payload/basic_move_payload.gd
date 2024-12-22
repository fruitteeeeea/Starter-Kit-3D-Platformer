extends PathFollow3D
class_name MovePayload

signal payload_move (payload01) #车子启动
signal payload_stop (payload01) #车子停下
signal payload_complete (payload01) #当到达终点时发出信号

@export var is_loop_payload := false #是否为无限循环的车子
@export var label : PackedScene
@export var alert_color : Material
@export var RigidItems : Array[PackedScene] #列表

var max_move_speed := 2.5 #玩家推动
var current_move_speed := 0.0
var reduce_speed := 0.1

var shoot_energy := 3.0 #射击推动
var current_energy := 0.0
var recover_speed := 1.0

var overall_speed := 0.0

var complete_debuff := [] #已完成的debuff挑战

func _ready() -> void:
	loop = is_loop_payload #根据车子的循环状况来决定 pathfollower3d 时候循环
