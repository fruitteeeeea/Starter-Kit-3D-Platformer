extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var drop_item: Marker3D = $DropItem

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D #开始导航

var speed = 1.5
const JUMP_VELOCITY = 4.5
var direction = Vector3.ZERO

var gravity = -25

var player : CharacterBody3D

func _ready() -> void:
	add_to_group("Enemy")
	await get_tree().create_timer(randf_range(.1, .5)).timeout
	animation_player.play("sprint")
	player = get_tree().get_first_node_in_group("player")
	
	#随机化
	speed = randf_range(1.2, 1.8)
	var rand_scale = randf_range(0.8, 1.2)
	scale = Vector3(rand_scale, rand_scale, rand_scale)


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y = gravity

	if is_instance_valid(player) && is_on_floor():
		#var direction = (player.global_position - global_position).normalized()
		navigation_agent_3d.set_target_position(player.global_position)

		#导航抓捕玩家
		var destination = navigation_agent_3d.get_next_path_position()
		var local_destination = destination - global_position
		direction = local_destination.normalized()
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

		velocity = direction * speed

	move_and_slide()


func die():
	drop_item.add_pineapple()
	queue_free()