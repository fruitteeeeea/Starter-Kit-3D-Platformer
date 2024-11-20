extends Node3D

@onready var animation_player: AnimationPlayer = $"button-floor-square2/AnimationPlayer"
@onready var normal_item_spwaner: Marker3D = $NormalItemSpwaner

func _on_area_3d_body_entered(body: Node3D) -> void:
	animation_player.play("toggle-on")
	normal_item_spwaner.spwan_normal_item()


func _on_area_3d_body_exited(body: Node3D) -> void:
	animation_player.play("toggle-off")
