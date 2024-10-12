extends CharacterBody3D

signal enemy_dead(enemy : CharacterBody3D)

@onready var character_ghost: Node3D = $character_ghost #模型

#生命值部分
@onready var health_component: Node = $HealthComponent
@onready var damage_number_spawn_point: Marker3D = $DamageNumberSpawnPoint
@onready var drop_item: Marker3D = $DropItem

#单次飞行距离
@export var flying_range := 5.0

#飞行的限制区域
@export var limit_topleft : Vector2
@export var limit_downright : Vector2

#做 sin 运动的参数
var time := 0.0
var is_floting := true

var player : CharacterBody3D
var level_manager : Node
var target_position : Vector3

#身体部分
var body_parts = []

func _ready() -> void:
	add_to_group("Enemy")
	
	await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
	player = get_tree().get_first_node_in_group("player")
	
	#获取关卡限制
	if get_parent().has_method("level_manager"):
		level_manager = get_parent()
		limit_topleft = Vector2\
		(level_manager.LevelSizeTopLeft.global_position.x, \
		level_manager.LevelSizeTopLeft.global_position.z)
		limit_downright = Vector2\
		(level_manager.LevelSizeDownRight.global_position.x, \
		level_manager.LevelSizeDownRight.global_position.z)

func _physics_process(delta: float) -> void:
	if is_floting:
		#rotate_y(2 * delta) # Rotation
		
		# Sine movement #第一个参数控制频率 第二个控制幅度
		position.y += (cos(time * 5) * 2) * delta
		
		time += delta
	
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	if target_position:
		global_position = global_position.lerp(target_position, 0.01)

#随机更改位置
func change_position():
	var new_posx = global_position.x + randf_range(-flying_range, flying_range)
	var new_posz = global_position.z + randf_range(-flying_range, flying_range)
	
	if limit_topleft && limit_downright: #限制在一个范围内
		new_posx = clamp(new_posx, limit_topleft.x, limit_downright.x)
		new_posz = clamp(new_posz, limit_topleft.y, limit_downright.y)
	
	target_position = Vector3(new_posx, global_position.y, new_posz)

#移动位置时候的旋转
func do_rotate():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(character_ghost, "rotation_degrees:y", character_ghost.rotation_degrees.y + 360.0, 1.0)


func _on_timer_timeout() -> void:
	change_position()
	do_rotate()


func take_damage(damge := 1.0):
	SoundManager.play_sfx("EnemyHurtSFX", true)
	damage_number_spawn_point.spwan_damage_number(damge)
	
	if health_component:
		health_component.damage(damge)
	
	if health_component.health <= 0:
		enemy_dead.emit(self)
		drop_item.add_pineapple()
		SoundManager.play_sfx("EnemyDeadSFX", true)
		queue_free()
