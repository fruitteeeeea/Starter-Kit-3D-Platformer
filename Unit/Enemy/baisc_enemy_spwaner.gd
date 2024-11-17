extends Marker3D

@export var enemy_scene : PackedScene #怪物类型 #我觉得每个生成器还是专注于一种怪物吧
#@export var enemy_scene : Array[PackedScene] = [] #怪物列表

@onready var spwan_timer: Timer = $SpwanTimer
@export var spwan_time : float #刷怪速度

@export var enemy_power : float #怪物强度
@export var rand_range := 8.0 #刷怪半径

@export var max_enemy_nb : int #限制能生成敌人的最大数量
var current_enemy_in_scene := [] #当前场景存在的该类型敌人

@export var auto_spwan := false

var debuglabel : Node

func _ready() -> void:
	EnemyStatusServer.enemy_spwaner.append(self)
	
	if auto_spwan:
		spwan_timer.wait_time = spwan_time #如果启用自动生成 计时器开始
		spwan_timer.start()

#调试 debug
func update_debuglabel():
	if !debuglabel:
		debuglabel = Hud.add_debuglabel()

	debuglabel.updata_label(name, current_enemy_in_scene.size())

func spwan_enemy():
	if current_enemy_in_scene.size() >= max_enemy_nb: #限制生成最大数量敌人
		return
	
	EnemyStatusServer.add_enemy(self)
	update_debuglabel()


func  remove_enemy(enemy01 : CharacterBody3D):
	current_enemy_in_scene.erase(enemy01)
	update_debuglabel()


func _on_spwan_timer_timeout() -> void:
	if current_enemy_in_scene.size() >= max_enemy_nb or !auto_spwan: #如果达到可生成敌人的上限
		return
	spwan_enemy()
