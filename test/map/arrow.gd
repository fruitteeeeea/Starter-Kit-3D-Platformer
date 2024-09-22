extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
var playe_in_area := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_3d.visible = false
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && playe_in_area:
		Dialogic.start("res://Dialog/timeline.dtl")
		print("开始对话")
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
