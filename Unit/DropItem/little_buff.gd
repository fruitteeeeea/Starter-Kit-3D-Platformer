extends Node

@export var BuffScene : PackedScene

func _on_area_3d_body_entered(body: Node3D) -> void:
	BuffServer.add_buff(BuffScene)
