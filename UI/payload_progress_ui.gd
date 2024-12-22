extends Control
class_name PayloadLabel

@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var progress_bar: ProgressBar = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/ProgressBar

var payload : PathFollow3D #车子节点
var payload_moving := false #是否在移动

func _process(delta: float) -> void:
	if payload_moving:
		progress_bar.value = PayloadServer.current_payload[payload]


func _payload_move(payload01):
	payload_moving = true
	change_visual_state(true)


func _payload_stop(payload01):
	payload_moving = false
	change_visual_state()


func _payload_complete(payload01):
	queue_free()


func change_visual_state(state01 := false):
	panel_container.visible = state01
