extends Control

@onready var transition_screen: Control = $"."

var show_pos := Vector2.ZERO
var hide_pos := Vector2(0, -900.0)
var hide_pos2 := Vector2(0, 900.0)

var move_tween : Tween

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug"):
		#show_colorrect()
	#
	#if event.is_action_pressed("debug2"):
		#hide_colorrect()

func show_colorrect():
	if move_tween:
		move_tween.kill()
	
	transition_screen.position = hide_pos
	move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(transition_screen, "position", show_pos, .5)

	
func hide_colorrect():
	if move_tween:
		move_tween.kill()
	
	move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(transition_screen, "position", hide_pos, .5)
	transition_screen.position = hide_pos
