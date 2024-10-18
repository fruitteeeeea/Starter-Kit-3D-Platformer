extends HBoxContainer

@onready var label_1: Label = $VBoxContainer/Label1
@onready var color_rect: ColorRect = $VBoxContainer/ColorRect
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var label_2: Label = $Label2

var colorrect_tween : Tween

#func updata_label(status_name : String, baisc_status : float, 
#modify_status : float, tempo_additon : float ): #更新标签参数
	#label_1.text = status_name
	#label_2.text = str(baisc_status) + "/" + str(modify_status) + "/" + str(tempo_additon)

func updata_label(status_name : String, modify_status : float): #更新标签参数
	do_colorrect_tween()
	label_1.text = status_name
	label_2.text = str(modify_status)

func update_progressbar(upgrade_progress : float):
	progress_bar.value = upgrade_progress

func do_colorrect_tween():
	if colorrect_tween:
		colorrect_tween.kill()
	
	color_rect.modulate.a = 1
	colorrect_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	colorrect_tween.tween_property(color_rect, "modulate:a", .1, .5)
	await colorrect_tween.finished
	print(color_rect.color.a)
	
