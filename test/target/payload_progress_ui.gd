extends Control
class_name PayloadLabel

@onready var panel_container: PanelContainer = $PanelContainer #标签本身
@onready var progress_bar: ProgressBar = $PanelContainer/MarginContainer/HBoxContainer/ProgressBar

var payload : PathFollow3D #车子节点
var payload_moving := false #是否在移动

#func _ready() -> void:
	#panel_container.visible = false
#
#
func _process(delta: float) -> void:
	if payload_moving:
		progress_bar.value = LevelTargetServer.current_payload[payload]


func _payload_move():
	payload_moving = true
	change_visual_state(true)
	pass


func _payload_stop():
	payload_moving = false
	change_visual_state()
	pass


func _payload_complete():
	pass


func change_visual_state(state01 := false):
	panel_container.visible = state01
