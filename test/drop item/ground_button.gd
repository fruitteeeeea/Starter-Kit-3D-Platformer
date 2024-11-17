extends Node3D

@onready var animation_player: AnimationPlayer = $"button-floor-square2/AnimationPlayer"
@export var Coin : PackedScene

func _on_area_3d_body_entered(body: Node3D) -> void:
	animation_player.play("toggle-on")
	for i in range(5):
		spwan_normal_item()
		await get_tree().create_timer(.1).timeout


func _on_area_3d_body_exited(body: Node3D) -> void:
	animation_player.play("toggle-off")


func spwan_normal_item():
	var item = Coin.instantiate()
	item.position = global_position
	get_tree().root.add_child(item)
