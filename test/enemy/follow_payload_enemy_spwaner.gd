extends Node3D

@export var EnemySpwanerList : Array[PackedScene] #生成器类型
var enemy_spwaner := []

@export var distance_to_payload := 5.0 #距离车子的距离 #这个值超过1就很难看清了 0.1就会离车子非常近

@export var spwaner_number : int #生成器数量
@export var spwaner_timer := 1.5 #生成时间
@export var enemy_number := 3 #生成敌人数量
@onready var enemy_spwan_timer: Timer = $EnemySpwanTimer

@export var enemy_strengeth_value := 100 #生成一定伤害值数量的敌人

func _ready() -> void:
	enemy_spwan_timer.wait_time = spwaner_timer
	
	for spwaner in EnemySpwanerList:
		var spwaner01 = spwaner.instantiate()
		add_child(spwaner01) #实例化敌人生成器节点
		enemy_spwaner.append(spwaner01) #加入到选择列表


func _on_enemy_spwan_timer_timeout() -> void:
	for i in range(enemy_number): #集束式生成敌人
		spwan_enemy()
		await get_tree().create_timer(.01).timeout


func spwan_enemy():
	if !LevelTargetServer.current_actived_payloads.size():
		return
	
	var current_payload = LevelTargetServer.current_actived_payloads.pick_random()
	if !current_payload:
		return
	
	#var pos = current_payload.surround_position.pick_random().global_position #随机寻找车子周围的一个位置
	#var pos = current_payload.get_surrounding_position(distance_to_payload)
	var pos = PayloadServer.GetPayloadAroundPos(distance_to_payload, 0, 0)
	
	pos += Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)) #进一步加工位置信息
	
	var spwaner = enemy_spwaner.pick_random()
	spwaner.global_position = pos
	spwaner.spwan_enemy()
