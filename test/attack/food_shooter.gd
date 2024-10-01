extends Node3D

var Food := preload("res://test/attack/bomb type/coconut_bomb.tscn")
#var Food := preload("res://test/attack/food.tscn")

#发射子弹位置
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2

#弹道属性
@export var bullet_velocity_y := 0.1
@export var bullet_velocity_x := 900

#用来确认玩家时候处于跳跃状态
var player : CharacterBody3D

#子弹数量
var bullet_number := 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("main_weapon"):
		for i in bullet_number:
			add_food()
			await get_tree().create_timer(.1).timeout

func add_food() -> void:

	player = get_tree().get_first_node_in_group("player")
	#先设置好要发射出来子弹的弹道属性
	if player: 
		if !player.is_on_floor(): #处于空中时
			bullet_velocity_y = 0.5
			bullet_velocity_x = 1600
		
		else: #处于地面时
			bullet_velocity_y = 0.1
			bullet_velocity_x = 900
	
	
	var food = Food.instantiate()
	get_tree().root.add_child(food)
	food.position = global_position #设定子弹位置
	var random_offset = Vector3(randf_range(-45, 45), 1, randf_range(-45, 45))
	food.rotation += random_offset #设定好子弹初始旋转
	var direction = ((marker_3d_2.global_position - marker_3d.global_position)\
	 + Vector3(0, bullet_velocity_y, 0)).normalized() 
	food.apply_central_force(direction * 900) #设计好弹道速度


func shoot_direction():
	var camera = get_viewport().get_camera_3d()
	if camera.has_method("shoot_ray"):
		var target_position = camera.shoot_ray
	pass
