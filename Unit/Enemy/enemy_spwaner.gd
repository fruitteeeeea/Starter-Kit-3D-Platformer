extends Marker3D

var rand_range := 8.0 #刷怪半径

@onready var timer: Timer = $Timer #刷怪间隔

@export var do_spwan_enemy := false #是否生成敌人
@export var activate := true

@export var Enemy : PackedScene #敌人类型
@export var spwan_enemy_number := 1 #生成敌人数量
@export var spwan_enemy_time := 1.0 #生成敌人间隔
@export var maximun_enemy := 25 #敌人最大数量
var enemy_array := [] #怪物队列

@export var level_manager : Node #确认关卡管理器

func _ready() -> void:
	if level_manager == null:
		printerr("level manager not found")
		return
	
	if !activate: #是否启用
		timer.stop()
	
	level_manager.battel_begain.connect(change_spwan_state.bind(true))
	level_manager.battel_finished.connect(change_spwan_state.bind(false))
	
	timer.wait_time = spwan_enemy_time

#更改生成状态
func change_spwan_state(state := false):
	do_spwan_enemy = state


func _on_timer_timeout() -> void:
	if enemy_array.size() >= maximun_enemy or !do_spwan_enemy: #如果超过最大生成敌人
		return
	
	spwan_enemy()

#生成敌人
func spwan_enemy():
	for i in range(spwan_enemy_number):
		var enemy = Enemy.instantiate() #生成敌人
		get_parent().add_child(enemy)
		enemy.global_position = global_position + \
		Vector3(randf_range(-rand_range, rand_range), 0, randf_range(-rand_range, rand_range)) #随机位置
		
		enemy_array.append(enemy) #添加到敌人数组中
		enemy.enemy_dead.connect(_remove_enemy_from_array_and_other_staff) #敌人链接移除数组信号

#执行删除敌人操作
func _remove_enemy_from_array_and_other_staff(enemy : CharacterBody3D):
	enemy_array.erase(enemy)
	#print(enemy_array.size())
	level_manager.add_combo()
