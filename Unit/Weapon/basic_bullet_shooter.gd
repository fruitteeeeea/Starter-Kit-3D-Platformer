extends Node3D

@export var Bullet : PackedScene #子弹节点

@onready var marker_3d: Marker3D = $Marker3D #发射子弹位置
@onready var marker_3d_2: Marker3D = $Marker3D2

@onready var fire_sfx: AudioStreamPlayer = $FireSFX #音效节点

@export var active := true #是否启用

@export var bullet_damage := 1.0 #子弹伤害
@export var bullet_number := 1 #子弹倍率
@export var bullet_scale := 1.0 #子弹体积
@export var spread_angle = 5.0 # 偏离的最大角度，以度数表示
@export var bullet_speed := 1.0 #子弹速度加成
@export var bullet_interval : float #多发子弹枪之间的间隔
 
@export var fire_rate := 0.5 #开火间隔

#确认玩家
var player : CharacterBody3D

func _ready() -> void:
	await get_tree().create_timer(.01).timeout
	player = get_tree().get_first_node_in_group("player") #获取玩家

#作为武器的标识
func weapon():
	pass

func _physics_process(delta: float) -> void:
	if !active:
		return
	
	face_to_mouse_cursor()

#寻找鼠标位置
func face_to_mouse_cursor():  
	var camera = get_viewport().get_camera_3d()
	if camera.has_method("shoot_ray"):
		var mouse_pos = camera.shoot_ray()
		if mouse_pos:
			get_parent().look_at(Vector3(mouse_pos.x, global_position.y, mouse_pos.z)) #确保该节点处于 Weapon 节点下

func _unhandled_input(event: InputEvent) -> void:
	if !player or !active:
		return
	
	if event.is_action_pressed("main_weapon"):
		for i in range(bullet_number): #子弹数量
			shoot_bullet()
			
			if bullet_interval: #如果有开火间隔
				await get_tree().create_timer(bullet_interval).timeout

#射击子弹
func shoot_bullet():
	fire_sfx.play()
	
	var bullet = Bullet.instantiate()
	
	bullet.bullet_damage = bullet_damage #设置伤害
	bullet.bullet_scale *= bullet_scale #设置体积
	bullet.bullet_speed *= bullet_speed #设置设置速度
	
	get_tree().root.add_child(bullet)
	bullet.position = marker_3d_2.global_position 
	var target_position = (marker_3d_2.global_position - marker_3d.global_position).normalized() #记得归一化向量
	bullet.bullet_direction = target_position


	
	#设置散射范围
	var random_direction = apply_horizontal_spread(target_position)
	bullet.bullet_direction = random_direction

# 给定方向添加水平偏移
func apply_horizontal_spread(base_direction: Vector3) -> Vector3:
	# 生成随机偏移角度
	var angle_offset = randf_range(-spread_angle, spread_angle)
	
	# 将角度转换为弧度
	angle_offset = deg_to_rad(angle_offset)
	
	# 在水平面（y 轴）上旋转方向向量
	var rotated_direction = base_direction.rotated(Vector3.UP, angle_offset)
	
	return rotated_direction.normalized()
