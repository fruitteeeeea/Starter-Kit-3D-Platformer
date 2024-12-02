extends Node3D
#一个基础的关卡包括 :环境光照 地图
#Payload及线路 Debuff数量 额外目标数量 刷怪数量 刷怪强度 动态难度
#任务时间

@export var world_envi : Environment #世界环境
@export var level_map : GridMap #关卡地图

@export var level_info := {
	"LevelTime" : 0.0,
	"EnemySpwaner" : [PackedScene],
}
