extends Node3D

@export var loot_pannel : Control

func _on_zoom_in_area_body_entered(body: Node3D) -> void:
	get_viewport().get_camera_3d().do_special_zoom(5.0, true)
	loot_pannel.move_pannel(0.0)


func _on_zoom_in_area_body_exited(body: Node3D) -> void:
	get_viewport().get_camera_3d().do_special_zoom()
	loot_pannel.move_pannel()
