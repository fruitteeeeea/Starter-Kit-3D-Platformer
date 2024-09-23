extends RigidBody3D

@onready var whole_ham_2: Node3D = $"whole-ham2"
@onready var particles_trail: CPUParticles3D = $ParticlesTrail
@onready var particles_trail_2: CPUParticles3D = $ParticlesTrail2
@onready var radius: Area3D = $Radius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explode()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func explode():
	particles_trail.emitting = true
	await get_tree().create_timer(1.8).timeout
	whole_ham_2.visible = false
	particles_trail.visible = false
	particles_trail_2.emitting = true
	hit_the_box()
	await particles_trail_2.finished
	queue_free()
	pass


func hit_the_box():
	var bodies = radius.get_overlapping_bodies()
	for obj in bodies:
		if obj.is_in_group("Box"):
			var source = self.global_position
			obj.get_hit(source)
	pass
