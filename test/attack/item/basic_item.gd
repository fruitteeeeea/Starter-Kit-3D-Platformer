extends Node3D

@onready var explain_label: Node3D = $ExplainLabel

@export_subgroup("Description")
@export var description01 := "item_name"
@export_multiline var description02 := "item_description"

@onready var label: Label = $ExplainLabel/Sprite3D/SubViewport/Panel/VBoxContainer/Label
@onready var label_2: Label = $ExplainLabel/Sprite3D/SubViewport/Panel/VBoxContainer/Label2

var player : CharacterBody3D
var player_inside := false

var increase_value := 0.1

func _ready() -> void:
	explain_label.hide()
	
	if label: #填写物品名字
		label.text = description01
	if label_2: #填写物品描述
		label_2.text = description02

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && player_inside:
		player_accept_power()
		SoundManager.play_sfx("SodaGlassSFX")
		print("1")
		queue_free()

func _on_detect_player_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		player = body
		player_inside = true
		explain_label.show()


func _on_detect_player_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		player = null
		player_inside = false
		explain_label.hide()

#角色应用buff
func player_accept_power():
	player.increas_power(increase_value)
