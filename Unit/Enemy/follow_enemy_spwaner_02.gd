extends Node3D
class_name EnemySpawner
#敌人生成器

@export_enum("Normal", "Follow") var SpwanerType : String = "Follow" #生成器种类
@export var enemy_scene : PackedScene #怪物类型

@export var wait_time := 0.5
@onready var enemy_spwan_timer: Timer = $EnemySpwanTimer

@export var max_enemy_nb : int = 25 #限制能生成敌人的最大数量
@export var enemy_number := 3 #敌人数量
@export var enemy_strength := 1.0 #敌人强度

@export var spwan_range := 5.0 #生成距离
@export var spwan_high := Vector3(0.0, 3.77, 0.0) #生成高度
@export var spwan_angle : float = randf_range(0.0, TAU) #生成角度 #90度就是载具正前方了
@export var angle_bais := 0.0 #角度概率

func _ready() -> void:
	enemy_spwan_timer.wait_time = wait_time
	EnemySpwanerServer.spwaner_info[self] = [] #加载敌人队列


func _on_enemy_spwan_timer_timeout() -> void:
	if !LevelTargetServer.current_actived_payloads.size():
		return 
		
	EnemySpwanerServer.activate_spwaner(self)
