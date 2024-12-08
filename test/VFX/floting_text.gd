extends Node3D

@onready var label_3d: Label3D = $Label3D
var damg01 : float

func _ready() -> void:
	if damg01:
		label_3d.text = str(damg01)


func floating_tween():
	
	pass
