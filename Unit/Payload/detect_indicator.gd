extends MeshInstance3D

@export var alert_color : Material

var display_tween : Tween
var init_scale := Vector3.ONE

func _ready() -> void:
	init_scale = scale
	scale = scale * .2
	transparency = 1.0


func do_display_tween(trans01 := 1.0, scale01 := .2):
	if display_tween:
		display_tween.kill()
	
	display_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	display_tween.tween_property(self, "transparency", trans01, .5)
	display_tween.tween_property(self, "scale", init_scale *  scale01, .5)


func _on_detect_player_body_entered(body: Node3D) -> void:
	do_display_tween(0.0, 1.0)


func _on_detect_player_body_exited(body: Node3D) -> void:
	do_display_tween()


func _on_detect_enemy_body_entered(body: Node3D) -> void:
	set_surface_override_material(0, alert_color)


func _on_detect_enemy_body_exited(body: Node3D) -> void:
	set_surface_override_material(0, null)
