extends Node3D

signal ui_main_weapon_fire_rate(time : float) #向ui发送射击冷却信号
signal ui_secondary_weapon_fire_rate(time : float) #向ui发送射击冷却信号

#发射子弹位置
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2

#音效节点
@onready var fire_sfx: AudioStreamPlayer = $FireSFX

#确认玩家
var player : CharacterBody3D

@export_subgroup("Properties")
#武器倍率
@export var main_weapon_multiplier := 1 #主武器倍率
@export var secondary_weapon_multiplier := 1 #副武器倍率

#射击间隔
@export var main_weapon_can_shoot := true #主武器射击间隔
@export var secondary_weapon_can_shoot := true #副武器射击间隔
@export var multiplier_timer := 0.1 #倍率武器发射间隔

#射速相关
@export var main_weapon_fire_rate := 1.0 #主武器发射速度
@export var secondary_weapon_fire_rate := 1.5 #副武器发射速度
@export var weapon_switching_delay := .5 #切换武器冷却

#弹道相关
@export var can_be_throw := true #可以被跳投

@export var normal_velocity_y := 1.0
@export var throw_velocity_y := 5.0 #跳投的时候 初始 y 轴速度 x5
@export var normal_velocity_x := 1.0
@export var throw_velocity_x := 0.8 #跳投的时候 初始 x 轴速度 x2

#幸运连击
@export var luck_combo_max := 5 #幸运连击上限
@export var luck_combo_time := 5.0 #幸运连击计时

@export_subgroup("Bullet")
@export var MainWeaponScene : PackedScene
@export var SecoundaryWeaponScene : PackedScene

@export_subgroup("Visual")
@export var main_weapon_modle : Resource #主武器模型
@export var secondary_weapon_modle : Resource #副武器模型

func _ready() -> void:
	await get_tree().create_timer(.01).timeout
	player = get_tree().get_first_node_in_group("player") #获取玩家

func _unhandled_input(event: InputEvent) -> void:
	if !player:
		return
	
	if event.is_action_released("main_weapon") && MainWeaponScene && main_weapon_can_shoot:
		main_weapon_can_shoot = false
		ui_main_weapon_fire_rate.emit() #向ui发送子弹冷却信号
		for i in main_weapon_multiplier: #发射相应子弹
			shoot_bullet(MainWeaponScene)
			await get_tree().create_timer(multiplier_timer).timeout #等待一下发射间隔
		
		await get_tree().create_timer(main_weapon_fire_rate).timeout #等待射击间隔
		main_weapon_can_shoot = true #回复射击状态
	
	if event.is_action_pressed("secondary_weapon") && SecoundaryWeaponScene && secondary_weapon_can_shoot:
		secondary_weapon_can_shoot = false
		ui_secondary_weapon_fire_rate.emit() #向ui发送子弹冷却信号
		for i in secondary_weapon_multiplier:
			shoot_bullet(SecoundaryWeaponScene)
			await get_tree().create_timer(multiplier_timer).timeout #等待一下发射间隔
		
		await get_tree().create_timer(secondary_weapon_fire_rate).timeout #等待射击间隔
		secondary_weapon_can_shoot = true #回复射击状态

#射击子弹
func shoot_bullet(bullet_scene : PackedScene):
	fire_sfx.play() #播放音效
	
	var bullet = bullet_scene.instantiate()
	if bullet.has_method("bullet") == false: #确认子弹确实是子弹
		return
	
	get_tree().root.add_child(bullet)
	bullet.position = global_position #设定子弹位置
	
	var bullet_velocity_y = bullet.BombSpeedY
	var bullet_velocity_x = bullet.BombSpeedX
	
	if !player.is_on_floor(): #处于空中时
		bullet_velocity_y = throw_velocity_y * bullet.BombSpeedY
		bullet_velocity_x = throw_velocity_x * bullet.BombSpeedX
		bullet.be_throw = true #标记炸弹处于投掷状态下丢出
		
	else: #处于地面时
		bullet_velocity_y = normal_velocity_y * bullet.BombSpeedY
		bullet_velocity_x = normal_velocity_x * bullet.BombSpeedX
	#应用弹道速度
	var direction = ((marker_3d_2.global_position - marker_3d.global_position)\
	 + Vector3(0, bullet_velocity_y, 0)).normalized() 
	bullet.apply_central_force(direction * bullet_velocity_x) #设计好弹道速度
	
	#设定好子弹初始旋转
	var random_offset = Vector3(randf_range(-45, 45), 1, randf_range(-45, 45))
	bullet.rotation += random_offset 
