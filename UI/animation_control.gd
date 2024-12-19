extends Node

@onready var vehiccle_animation_player: AnimationPlayer = $"../vehicle/flag/AnimationPlayer"
@onready var character_animation_player: AnimationPlayer = $"../Character/AnimationPlayer"

func _ready() -> void:
	vehiccle_animation_player.play("moving")
	character_animation_player.play("idle")
 
