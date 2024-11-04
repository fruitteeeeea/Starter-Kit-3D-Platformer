extends Marker3D

@export var enemy_scene : Array[PackedScene] = [] #怪物列表
@export var rand_range := 8.0 #刷怪半径

func _ready() -> void:
	EnemyStatusServer.enemy_spwaner_marker.append(self)
