extends Marker3D

@export var enemy_scene : PackedScene #怪物类型 #我觉得每个生成器还是专注于一种怪物吧
#@export var enemy_scene : Array[PackedScene] = [] #怪物列表

@onready var spwan_timer: Timer = $SpwanTimer
@export var spwan_time : float #刷怪速度

@export var enemy_power : float #怪物强度
@export var rand_range := 8.0 #刷怪半径


func _ready() -> void:
	EnemyStatusServer.enemy_spwaner.append(self)
	spwan_timer.wait_time = spwan_time


func _on_spwan_timer_timeout() -> void:
	EnemyStatusServer.add_enemy(self)
