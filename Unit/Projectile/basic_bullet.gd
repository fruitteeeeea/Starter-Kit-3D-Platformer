extends CharacterBody3D

@onready var model: Node3D = $Model
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
const normal_radius_scale := .1

var direction = Vector3.ZERO

@export var speed_curve: Curve
@export var volume_curve: Curve
@export var lifespan := 0.4 #存活时间
var elapsed_time: float = 0.0 #经过时间

@export var damage := 1.0 #子弹伤害
@export var scale01 := 1.0 #子弹的体积 
@export var speed = 38.0 #子弹速度 子弹的持续时间由子弹速度和阻力决定
@export var volume := 1.0 #变化体积
@export var speed_damp := -0.3 #子弹阻力 

var kockback_force := 0 #子弹击退力度
@export var max_knockback_force := 8 * 1.5 #最大击退力度
@export var min_knockback_force := 8 * 0.1 #最小击退力度
@export var knockback_force_reducerate := 3 #击退力衰减

var is_hit := false

func _ready() -> void:
	kockback_force = max_knockback_force
	#设置属性
	#model.scale *= volume
	#var new_radius = normal_radius_scale * volume
	#collision_shape_3d.shape.radius = new_radius
	scale *= scale01
	


func _physics_process(delta: float) -> void:
	elapsed_time += delta #度过时间
	var t = elapsed_time / lifespan #正则化时间 0 到 1 #仍处于生命周期
	
	if t > 1.0 && !is_hit: #度过生命周期时间
		queue_free()
	
	speed *= speed_curve.sample(t)
	volume = volume_curve.sample(t)
	
	rotation.y = atan2(direction.x, direction.z) #旋转
	velocity = direction * speed
	scale = Vector3(volume, volume, volume)
	
	#speed = lerpf(speed, 0, speed_damp) #平滑减少速度
	
	
	#if kockback_force > min_knockback_force:
		#kockback_force -= knockback_force_reducerate #减少击退力度
	
	#if speed < 0.1: #小于某个设定的值 就释放掉
		#queue_free()
		
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(damage)
		#body.apply_knockback(global_position)
		VisualServer.hit_stop_medium()
		VisualServer.do_camerashake()
		
		queue_free()
	
	if body.is_in_group("RigidEnemy"):
		body.being_knockback(self, kockback_force)
		VisualServer.hit_stop_medium()
		VisualServer.do_camerashake()
		
		queue_free()

	if body.has_method("target_enemy_spwaner"):
		body.get_hit(1)
		VisualServer.do_camerashake()
		VisualServer.hit_stop_medium()
		queue_free()

	if body.has_method("state_enemy"):
		var knockback_direction = (self.global_position - body.global_position).normalized()
		body.take_damage(kockback_force, damage)
		VisualServer.hit_stop_medium()
		VisualServer.do_camerashake()
		is_hit = true
		$Area3D.queue_free()
		await get_tree().create_timer(.4).timeout
		queue_free()
