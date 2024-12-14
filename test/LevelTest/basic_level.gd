extends Node3D
#一个基础的关卡包括 :环境光照 地图
#Payload及线路 Debuff数量 额外目标数量 刷怪数量 刷怪强度 动态难度
#任务时间

@export var world_envi : Environment #世界环境
@export var level_map : GridMap #关卡地图


@onready var entery_point: Marker3D = $EnteryPoint #初始地点
@onready var basic_player: CharacterBody3D = $"Basic Player"


@export var level_info := {
	"LevelTime" : 0.0,
	"EnemySpwaner" : [PackedScene],
}

func _ready() -> void:
	print(get_tree().current_scene.name) 
	pass

func update_player(pos: Vector3): #关卡文件会更新玩家节点
	$"Basic Player".global_position = pos
	pass
