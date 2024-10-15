extends Label

var inital_pos : float
var refresh_tween : Tween
var combo := 0

@export var level_manager : Node
@export var max_combo := 10

@onready var panel_container: PanelContainer = $"../PanelContainer"
var pannel_inital_pos : float

@onready var progress_bar: ProgressBar = $"../ProgressBar"
@export var luckcombo_countdown := 5.0 #幸运连击倒计时
var countdown_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inital_pos = position.y
	pannel_inital_pos = panel_container.position.y
	level_manager.add_combo_signal.connect(_add_combo)

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("mouse_right"):
		#_add_combo()

func _add_combo():
	do_countdown_tween() #只要有杀死敌人 都要刷新进度条
	if combo >= max_combo:
		return

	combo += 1
	text = str(combo)
	do_refresh_tween()


func do_refresh_tween():
	if refresh_tween:
		refresh_tween.kill()
	
	position.y = inital_pos - 64
	scale = Vector2(2.0, 2.0)

	panel_container.position.y = pannel_inital_pos - 64

	refresh_tween = create_tween()
	refresh_tween.set_ease(Tween.EASE_OUT)
	refresh_tween.set_trans(Tween.TRANS_ELASTIC)
	refresh_tween.set_parallel()
	refresh_tween.tween_property(self,"position:y", inital_pos, 1.2)
	refresh_tween.tween_property(self,"scale", Vector2.ONE, 1.2)
	refresh_tween.tween_property(panel_container, "position:y", pannel_inital_pos, 1.2)


func do_countdown_tween():
	if countdown_tween:
		countdown_tween.kill()
	
	progress_bar.value = progress_bar.max_value
	
	countdown_tween = create_tween()
	countdown_tween.set_trans(Tween.TRANS_LINEAR)
	countdown_tween.tween_property(progress_bar,"value", 0, luckcombo_countdown)
	await countdown_tween.finished
	change_ui_state()


func change_ui_state():
	combo = 0
