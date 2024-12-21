extends Node3D

@export var ChestList : Array[PackedScene] #生成器类型
@export var Chest : PackedScene
var chest_list := []

@export var distance_to_payload := .3

@export var spwaner_number : int #生成器数量
@export var spwaner_timer := 5.0 #生成时间
@export var enemy_number := 2 #生成敌人数量
@onready var chest_spwan_timer: Timer = $ChestSpwanTimer

func _ready() -> void:
	chest_spwan_timer.wait_time = spwaner_timer
	
	for spwaner in ChestList:
		var spwaner01 = spwaner.instantiate()
		add_child(spwaner01) #实例化敌人生成器节点
		chest_list.append(spwaner01) #加入到选择列表


func _on_chest_spwan_timer_timeout() -> void:
	spwan_chest()
	pass # Replace with function body.


func spwan_chest():
	if !PayloadServer.current_actived_payloads.size():
		return
	
	var current_payload = PayloadServer.current_actived_payloads.pick_random()
	if !current_payload:
		return
	
	#var pos = current_payload.surround_position.pick_random().global_position #随机寻找车子周围的一个位置
	var pos = current_payload.get_surrounding_position(distance_to_payload)
	#var pos = PayloadServer.GetPayloadAroundPos(distance_to_payload, 0, 0)
	
	pos += Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)) #进一步加工位置信息
	
	var chest = Chest.instantiate()
	get_tree().root.add_child(chest)
	chest.global_position = pos
	
