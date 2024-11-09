extends CharacterBody3D

var normal_speed
var escape_speed

var direction

#行动路线是 闲逛
#如果发现玩家 则进入逃脱状态

func _physics_process(delta: float) -> void:
	move_and_slide()
