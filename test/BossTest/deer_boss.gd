extends CharacterBody3D

#视觉效果
@export var hurt_particle : PackedScene #击中特效
@export var blood_trail : PackedScene #死亡血迹

#击中闪烁 #身体部分
@onready var reindeer: MeshInstance3D = $Model/reindeer
var body_parts := [reindeer]

@export var hit_flash_material : Material #受击时显示的材质
@export var FloatingText : PackedScene

@export var knockback_recover := .1 * 2 #击退中的恢复速度
var knockback_direction : Vector3 #击退方向 相对于玩家的位置
var knockback_strength : float #攻击来源的击退强度

func state_enemy():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor():
		velocity.y -= 25 * delta

	move_and_slide()

#受到伤害
func take_damage(knockback_strength01 : float, damge : float):
	#effect
	VisualServer.spwan_hurt_particle(hurt_particle, global_position)
	VisualServer.do_hit_flash(body_parts, hit_flash_material)
	SoundManager.play_sfx("EnemyHurtSFX", true)
	VisualServer.spwan_bloodtrail(blood_trail, global_position, global_rotation) #生成血迹
	VisualServer.spwan_floating_text(FloatingText, global_position, damge)
	
	var player = get_tree().get_first_node_in_group("player")
	knockback_direction = (global_position - player.global_position).normalized() * 3 + Vector3(0, 3, 0) #加一个向上的力
	knockback_strength  = knockback_strength01
