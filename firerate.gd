extends HBoxContainer

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WeaponServers.weapon_fire.connect(activate_progress_bar)

#主武器进度条
func activate_progress_bar(time : float):
	progress_bar.value = progress_bar.min_value
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(progress_bar, "value", progress_bar.max_value, time)
