extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var knife_damge := 3.0
@export var kockback_force := 8.0 #刀子击退力度

func do_stab():
	show()
	animation_player.play("stab")
	await animation_player.animation_finished
	hide()


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.has_method("state_enemy"):
		var knockback_direction = (self.global_position - body.global_position).normalized()
		body.take_damage(kockback_force, knife_damge)
