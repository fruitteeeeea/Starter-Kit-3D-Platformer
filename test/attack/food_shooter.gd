extends Node3D

var Food := preload("res://test/attack/food.tscn")
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		add_food()
		pass

func add_food() -> void:
	var food = Food.instantiate()
	get_tree().root.add_child(food)
	food.position = global_position
	var random_offset = Vector3(randf_range(-5, 5), 1, randf_range(-5, 5))
	food.rotation += random_offset
	var direction = ((marker_3d_2.global_position - marker_3d.global_position) + Vector3(0, .1, 0)).normalized() 
	food.apply_central_force(direction * 900)
	pass
