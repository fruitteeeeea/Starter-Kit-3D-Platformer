extends Label

var inital_pos : float
var refresh_tween : Tween
var combo := 0

@export var level_manager : Node
@export var max_combo := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inital_pos = position.y
	level_manager.add_combo_signal.connect(_add_combo)

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("mouse_right"):
		#_add_combo()

func _add_combo():
	if combo >= max_combo:
		pass

	combo += 1
	text = str(combo)
	do_refresh_tween()


func do_refresh_tween():
	if refresh_tween:
		refresh_tween.kill()
	
	position.y = inital_pos - 64
	scale = Vector2(2.0, 2.0)

	refresh_tween = create_tween()
	refresh_tween.set_ease(Tween.EASE_OUT)
	refresh_tween.set_trans(Tween.TRANS_ELASTIC)
	refresh_tween.set_parallel()
	refresh_tween.tween_property(self,"position:y",inital_pos, 1.2)
	refresh_tween.tween_property(self,"scale", Vector2.ONE, 1.2)
