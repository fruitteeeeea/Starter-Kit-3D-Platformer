extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
var player : CharacterBody3D
var playe_in_area := false
var is_in_display := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_3d.visible = false
	player = get_tree().get_first_node_in_group("player")
	Dialogic.timeline_ended.connect(_dialogue_end)
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && playe_in_area && player && !is_in_display:
		#进入播放对话状态
		is_in_display = true

		#接管玩家控制
		get_viewport().set_input_as_handled()
		player.is_freez = true
		player.movement_velocity = Vector3.ZERO

		#开始对话
		Dialogic.start("res://Dialog/timeline.dtl")

func _dialogue_end():
	player.is_freez = false
	is_in_display = false
	pass

func show_label(visible01 := false):
	sprite_3d.visible = visible01
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	show_label(true)
	playe_in_area = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	show_label(false)
	playe_in_area = false
