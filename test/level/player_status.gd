extends Control

@export var player : CharacterBody3D #获取玩家
var player_weapon : Node3D #获取玩家武器

@onready var progress_bar: ProgressBar = $Weapon/ProgressBar
@onready var progress_bar_2: ProgressBar = $Weapon/ProgressBar2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player && player.specific_weapon:
		player_weapon = player.specific_weapon
		player_weapon.ui_main_weapon_fire_rate.connect(activate_progress_bar)
		player_weapon.ui_secondary_weapon_fire_rate.connect(activate_progress_bar_2)

#主武器进度条
func activate_progress_bar():
	var time = player_weapon.main_weapon_fire_rate
	progress_bar.value = progress_bar.min_value
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(progress_bar, "value", progress_bar.max_value, time)

#副武器进度条
func activate_progress_bar_2():
	var time = player_weapon.secondary_weapon_fire_rate
	progress_bar_2.value = progress_bar_2.min_value
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(progress_bar_2, "value", progress_bar_2.max_value, time)
