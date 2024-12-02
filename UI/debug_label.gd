extends PanelContainer


@onready var label_1: Label = $HBoxContainer/Label1
@onready var label_2: Label = $HBoxContainer/Label2
@onready var color_rect: ColorRect = $ColorRect

var colorrect_tween : Tween

#更新label文本
func updata_label(status_name : String, modify_status : float): #更新标签参数
	do_colorrect_tween()
	label_1.text = status_name
	label_2.text = str(modify_status)

#闪烁label
func do_colorrect_tween():
	if colorrect_tween:
		colorrect_tween.kill()
	
	color_rect.modulate.a = 1
	colorrect_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	colorrect_tween.tween_property(color_rect, "modulate:a", .1, .5)
	await colorrect_tween.finished
