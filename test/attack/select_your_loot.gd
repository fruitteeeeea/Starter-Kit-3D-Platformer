extends Control

var defalt_posy := -900.0
var show_posy := 0.0

var move_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = defalt_posy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move_pannel(posy01 := defalt_posy):
	if move_tween:
		move_tween.kill()
	
	move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self, "position:y", posy01, .5)
