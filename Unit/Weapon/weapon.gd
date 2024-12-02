extends Node3D
class_name Weapon
#武器基类 拥有瞄准 射击两个功能

@export var active := true #是否启用

@export_enum("Bullet", "Bomb") var WeaponType := "Bullet" #武器种类

@export var ProjectileScene : PackedScene #弹药场景
@export var projectile_number := 3 #弹药数量
@export var projectile_damage := 1.0 #弹药伤害加成
@export var fire_colddown := 0.5 #射击冷却
@export var fire_interval := 0.1 #射击间隔


func _physics_process(delta: float) -> void:
	if !active:
		hide()
		return
	
	face_to_mouse_cursor()

#瞄准 寻找鼠标位置
func face_to_mouse_cursor():  
	var camera = get_viewport().get_camera_3d()
	if camera.has_method("shoot_ray"):
		var mouse_pos = camera.shoot_ray()
		if mouse_pos:
			get_parent().look_at(Vector3(mouse_pos.x, global_position.y, mouse_pos.z)) #确保该节点处于 Weapon 节点下

#发射 向武器服务器发送发射请求
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("main_weapon"):
		do_fire()

#射击 在子类完成向武器服务器发射请求
func do_fire():
	pass
