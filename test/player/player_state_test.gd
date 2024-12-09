extends CharacterBody3D
class_name Player

var is_freez := false

@export var Camera: Camera3D
var movement_velocity: Vector3 #移动速度
var rotation_direction: float
var gravity = 0

@onready var state_chart: StateChart = $StateChart

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if !is_freez:
		handle_controls(delta)
	
	handle_gravity(delta)
	
	var applied_velocity: Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	velocity = applied_velocity
	move_and_slide()

	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 25) #人物转身速度

#控制玩家的水平移动
func handle_controls(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, Camera.rotation.y) #根据镜头旋转方向
	
	movement_velocity = input * PlayerSatusServer.get_player_status("move_speed") * delta
	if Input.is_action_just_pressed("jump"):
		jump()

func handle_gravity(delta):
	gravity += 25 * delta
	if gravity > 0 and is_on_floor():
		gravity = 0


func jump():
	gravity = - PlayerSatusServer.get_player_status("jump_hight")
