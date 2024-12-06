extends CharacterBody3D

@export var speed_curve: Curve
@export var volume_curve: Curve

@export var lifespan := 0.4 #存活时间
var elapsed_time: float = 0.0 #经过时间

var volume := 1.0
var speed := 66.0
var direction := Vector3.RIGHT

func _physics_process(delta: float) -> void:
	rotation.y = atan2(direction.x, direction.z) #旋转
	elapsed_time += delta
	var t = elapsed_time / lifespan #正则化时间 0 到 1 #仍处于生命周期
 
	if t > 1.0:
		queue_free()

	# 从曲线获取速度和体积
	speed *= speed_curve.sample(t)
	volume = volume_curve.sample(t)

	scale = Vector3(volume, volume, volume)
	velocity = speed * direction
	move_and_slide()
