extends Node3D

@export var target : Node3D #相机追踪目标
@onready var camera_3d: Camera3D = $Camera3D

var zoom = 1

func _physics_process(delta: float) -> void:
	if target:
		self.position = self.position.lerp(target.position, delta * 4)
		camera_3d.position = camera_3d.position.lerp(Vector3(10, 13, 10), 8 * delta) #相机相对于 跟踪节点的偏移
 
