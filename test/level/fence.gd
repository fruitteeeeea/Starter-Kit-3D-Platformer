extends GridMap

var level_manager : Node

var fence_on := 0
var fence_off := -1.45

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().has_method("level_manager"):
		level_manager = get_parent()
		level_manager.battel_begain.connect(change_fence_state.bind(fence_on))
		level_manager.battel_finished.connect(change_fence_state.bind(fence_off))
	
	position.y = fence_off


func change_fence_state(state := fence_off):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position:y", state, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
