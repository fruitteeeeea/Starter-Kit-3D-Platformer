extends Control

@onready var panel_container: PanelContainer = $PanelContainer #关卡完成面板
@onready var level_time_left: Label = $HBoxContainer/LevelTimeLeft #关卡剩余时间

@export var level_manager : Node

var level_complete_hide_pos := -1620.0
var level_complete_show_pos := -16.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_manager.battel_finished.connect(show_level_complete) #链接完成关卡信号


func _process(delta: float) -> void:
	level_time_left.text = "%02d:%02d" % _time_left()

#获取计时器剩余时间
func _time_left():
	var time_left = level_manager.state_timer.time_left
	var minute = floor(time_left / 60)#这里的floor表示向下取整 确保取到的分钟为整数 
	var second = int(time_left - minute * 60)
	return[minute, second]


func show_level_complete():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(panel_container, "position:x", level_complete_show_pos, .8)
	tween.tween_property(panel_container, "position:x", level_complete_hide_pos, .8).set_delay(1.4)
