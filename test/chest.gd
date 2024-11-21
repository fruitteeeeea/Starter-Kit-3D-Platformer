extends Node3D

@onready var animation_player: AnimationPlayer = $chest2/AnimationPlayer
@onready var chest_2: Node3D = $chest2
@onready var normal_item_spwaner: Marker3D = $NormalItemSpwaner
@export var life_time := 7.7

func _ready() -> void:
	await get_tree().create_timer(life_time).timeout
	queue_free()

func get_open():
	normal_item_spwaner.spwan_normal_item()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(chest_2, "scale", Vector3(1.2, .2, 1.2), .1)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(chest_2, "scale", Vector3.ONE, .4)
	
	animation_player.play("open")
	
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_detect_player_body_entered(body: Node3D) -> void:
	get_open()
