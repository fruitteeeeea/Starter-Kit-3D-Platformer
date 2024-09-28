extends RigidBody3D

@onready var whole_ham_2: Node3D = $"whole-ham2"
@onready var particles_trail: CPUParticles3D = $ParticlesTrail
@onready var particles_trail_2: CPUParticles3D = $ParticlesTrail2
@onready var radius: Area3D = $Radius

var camera : Camera3D

@export var ExplodeLag := 1.8 #抛出后的倒计时
@export var CameraTrauma := 0.4 #添加的镜头晃动

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	await get_tree().create_timer(ExplodeLag).timeout #炸弹冷却
	explode()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func explode():
	if camera.has_method("add_trauma"):
		camera.add_trauma(CameraTrauma)

	particles_trail.emitting = true
	whole_ham_2.visible = false
	particles_trail.visible = false
	particles_trail_2.emitting = true
	hit_the_box()
	await particles_trail_2.finished

	queue_free()


func hit_the_box():
	var bodies = radius.get_overlapping_bodies()
	#处理敌人
	for obj in bodies:
		if obj.is_in_group("Enemy"):
			obj.die()
			#var source = self.global_position
			#obj.get_hit(source)

	#处理环境物品
	for obj in bodies:
		if obj.is_in_group("Box"):
			var source = self.global_position
			obj.get_hit(source)
	pass
