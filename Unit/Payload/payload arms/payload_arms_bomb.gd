extends Node3D
#车子的抛出炸弹

@export var bomb_damge := 3.0
@export var kockback_force := 8.0 #子弹击退力度

@export var random_posxz := Vector2(-6.8, 6.8)
@export var random_y := Vector2(2.8, 4.8)
@export var tween_interval := .8

@onready var explode_particles: CPUParticles3D = $ExplodeParticles
@onready var explode_radius: Area3D = $ExplodeRadius
@onready var model: Node3D = $Model

func _ready() -> void:
	drop_to_random_pos()

#初始随机掉到某个地方
func drop_to_random_pos():
	var random_posx = randf_range(random_posxz.x, random_posxz.y)
	var random_posz = randf_range(random_posxz.x, random_posxz.y)
	var random_posy = randf_range(random_y.x, random_y.y)
	var orgin_posy = position.y
	
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC) #tween 的过度极大影响了炸弹抛出去的视觉感受
	tween.tween_property(self, "position:x", position.x + random_posx, tween_interval)
	tween.tween_property(self, "position:z", position.z + random_posz, tween_interval) #水平方向移动
	
	tween.tween_property(self, "position:y", position.y + random_posy, tween_interval / 2 )
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "position:y", orgin_posy, tween_interval / 2).set_delay(tween_interval / 2) #垂直方向移动
	await tween.finished 
	model.hide()
	explode()

#爆炸
func explode():
	VisualServer.do_camerashake(.3)
	explode_particles.emitting = true
	
	#对爆炸半径内的物品进行操作
	var bodies = explode_radius.get_overlapping_bodies()
	for enemy in bodies: #伤害敌人
		if enemy.has_method("state_enemy"):
			var knockback_direction = (self.global_position - enemy.global_position).normalized()
			enemy.take_damage(kockback_force, bomb_damge)
			VisualServer.hit_stop_medium()

	await explode_particles.finished
	queue_free()
