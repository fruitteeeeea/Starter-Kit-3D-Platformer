extends Control

@onready var texture_rect: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.modulate.a = randf_range(0.0, 1.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
