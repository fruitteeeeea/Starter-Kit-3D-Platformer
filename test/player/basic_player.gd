extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var Camera: Camera3D
@export var specific_weapon : Node3D
@export var activate_followbot := false
@export var FollowBot : PackedScene

@onready var weapon: Node3D = $Weapon


@export_subgroup("Properties")
#@export var movement_speed = 300
@export var jump_strength = 7

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

var coins = 0

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer
@onready var follow_point: Marker3D = $Character/FollowPoint #无人机追踪点

var is_freez := false

var camera : Camera3D

func _ready() -> void:
	add_to_group("player")
	
	WeaponServers.Player = self
	
	camera = get_viewport().get_camera_3d()
	if activate_followbot: #如果需要添加无人机
		add_bot()

func player():
	pass

#添加无人机
func add_bot():
	await get_tree().create_timer(.5).timeout
	if FollowBot && follow_point:
		var follow_bot = FollowBot.instantiate()
		get_tree().root.add_child(follow_bot)
		follow_bot.position = follow_point.global_position
		follow_bot.player = self
		follow_bot.follow_point  = follow_point #赋予跟踪marker3d


func _physics_process(delta):

	# Handle functions

	if !is_freez:
		handle_controls(delta)

	handle_gravity(delta)

	handle_effects(delta)

	# Movement

	var applied_velocity: Vector3

	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity

	velocity = applied_velocity
	move_and_slide()

	# Rotation

	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 25) #人物转身速度

	# Falling/respawning

	if position.y < -10:
		get_tree().reload_current_scene()

	# Animation for scale (jumping and landing)

	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)

	# Animation when landing

	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://sounds/land.ogg")

	previously_floored = is_on_floor()

# Handle animation(s)

func handle_effects(delta):

	particles_trail.emitting = false
	sound_footsteps.stream_paused = true

	if is_on_floor():
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		#var speed_factor = horizontal_velocity.length() / movement_speed / delta
		var speed_factor = horizontal_velocity.length() / PlayerSatusServer.get_player_status("move_speed") / delta
		if speed_factor > 0.05:
			if animation.current_animation != "walk":
				animation.play("walk", 0.1)
				camera.do_zoom(camera.run_zoom, camera.run_tween_time)

			if speed_factor > 0.3:
				sound_footsteps.stream_paused = false
				sound_footsteps.pitch_scale = speed_factor

			if speed_factor > 0.75:
				particles_trail.emitting = true

		elif animation.current_animation != "idle":
			camera.do_zoom(camera.defult_zoom, camera.defult_tween_time)
			animation.play("idle", 0.1)

	elif animation.current_animation != "jump":
		animation.play("jump", 0.1)

# Handle movement input

func handle_controls(delta):

	# Movement

	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	input = input.rotated(Vector3.UP, Camera.rotation.y)

	if input.length() > 1:
		input = input.normalized()

	#movement_velocity = input * movement_speed * delta
	movement_velocity = input * PlayerSatusServer.get_player_status("move_speed") * delta

	# Jumping

	if Input.is_action_just_pressed("jump"):

		if jump_single or jump_double:
			jump()

# Handle gravity

func handle_gravity(delta):

	gravity += 25 * delta

	if gravity > 0 and is_on_floor():

		jump_single = true
		gravity = 0

# Jumping

func jump(strength01 = jump_strength):

	Audio.play("res://sounds/jump.ogg")

	#gravity = -strength01
	gravity = - PlayerSatusServer.get_player_status("jump_hight")

	model.scale = Vector3(0.5, 1.5, 0.5)

	if jump_single:
		jump_single = false;
		jump_double = true;
	else:
		jump_double = false;

# Collecting coins #发送收集物品信号

func collect_coin():

	coins += 1

	coin_collected.emit(coins)
