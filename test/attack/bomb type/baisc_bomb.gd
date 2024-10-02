extends RigidBody3D
class_name Bomb #炸弹基类

@onready var explode_radius: Area3D = $ExplodeRadius
@onready var collision_shape_3d: CollisionShape3D = $ExplodeRadius/CollisionShape3D

var camera : Camera3D

enum BombType {BULLET, BOMB} #炸弹类型

@export_subgroup("Stata")
@export var Type = BombType.BOMB #炸弹类型
@export var IsHitExplode := false #接触爆炸

@export var BombSpeed := 200 #发射速度
@export var BombRotation := 20 #发射旋转

@export var ExplodeLag := 1.8 #抛出后的倒计时
@export var CameraTrauma := 0.4 #添加的镜头晃动

@export var ExplodeRadius := 0.5 #爆炸半径
@export var ExplodeDamage := 1.0 #爆炸伤害

@export var AffectEnvivormentObject := true #影响环境物品
@export var ImpactForce := 2800 #爆炸冲击力

@export_subgroup("Visual")
@export var BombModle : Node3D #炸弹模型
@export var IdleParticle : CPUParticles3D #闲置粒子
@export var TrailParticle : CPUParticles3D #尾迹粒子
@export var ExplodeParticle : CPUParticles3D #爆炸发生的粒子

func _ready() -> void:
	collision_shape_3d.shape.radius = ExplodeRadius #应用爆炸半径
	
	bomb_state() #分情况引爆炸弹

#分情况爆炸
func bomb_state():
	await get_tree().create_timer(ExplodeLag).timeout
	explode() 

#直击检测
func _on_direct_hit_detect_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy") && IsHitExplode:
		explode()

#爆炸
func explode():
	#应用相机抖动
	camera = get_viewport().get_camera_3d()
	if camera.has_method("add_trauma"):
		camera.add_trauma(CameraTrauma)
	
	#对爆炸半径内的物品进行操作
	var bodies = explode_radius.get_overlapping_bodies()
	for enemy in bodies: #伤害敌人
		if enemy.is_in_group("Enemy"):
			hit_the_enemy(enemy)
	
	for object in bodies: #冲击物品
		if object.is_in_group("Box") && AffectEnvivormentObject:
			hit_the_envi_object(object)
	
	#视觉效果
	BombModle.visible = false
	IdleParticle.emitting = false
	TrailParticle.emitting = false
	ExplodeParticle.emitting = true
	
	#销毁节点
	await ExplodeParticle.finished
	queue_free()

#伤害敌人
func hit_the_enemy(enemy01 : CharacterBody3D):
	enemy01.take_damage(ExplodeDamage)

#冲击环境物品
func hit_the_envi_object(object01 : RigidBody3D):
	object01.apply_central_force((object01.global_position - global_position).normalized() * ImpactForce)
