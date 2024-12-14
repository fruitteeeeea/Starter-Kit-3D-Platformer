extends Node2D

var number := 5.0
var activated := false

var get_hurt := false
var damge := 1.0
var current_damge := 0.0

@onready var state_chart: StateChart = $StateChart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		state_chart.send_event("to_chase")
	if event.is_action_released("mouse_right"):
		state_chart.send_event("to_idle")

	if event.is_action_pressed("jump"):
		state_chart.send_event("to_hurt")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	$PanelContainer/Label.text = str(round(number * 10) / 10.0)
	$PanelContainer2/Label.text = str(activated)


func _on_idle_state_entered() -> void:
	activated = false


func _on_chase_state_entered() -> void:
	activated = true


func _on_chase_state_physics_processing(delta: float) -> void:
	if get_hurt:
		return
	
	number += 10 * delta #证明了平行状态确实可以打断


func _on_normal_state_entered() -> void:
	get_hurt = false


func _on_hurt_state_entered() -> void:
	current_damge = 0.0
	get_hurt = true


func _on_hurt_state_physics_processing(delta: float) -> void:
	number -= 1 * delta
	current_damge += 1 * delta
	if current_damge >= damge:
		state_chart.send_event("to_normal")
	
	
