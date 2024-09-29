extends Node

@export var trauma_reduction_rate := 2.0 #抖动恢复

@export var max_x := 5.0
@export var max_y := 5.0
@export var max_z := 5.0

@export var noise : FastNoiseLite
@export var noise_speed := 50.0

@onready var camera_3d: Camera3D = $".."

var trauma := 0.0
var initial_rotation : Vector3

var time := 0.0

func _ready() -> void:
	initial_rotation = camera_3d.rotation_degrees
	camera_3d.add_trauma_signal.connect(add_trauma)

func _process(delta: float) -> void:
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	camera_3d.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	camera_3d.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	camera_3d.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("main_weapon"):
		#add_trauma(.6)

#增加抖动
func add_trauma(trauma_amount : float):
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

#平滑抖动
func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed : int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)
