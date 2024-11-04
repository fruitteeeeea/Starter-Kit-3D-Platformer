extends Marker3D

@export var Pineapple : PackedScene #掉落物品
@export var min_drop_number := 4
@export var max_dorp_number := 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_pineapple():
	for i in randi_range(min_drop_number, max_dorp_number):
		var pineapple = Pineapple.instantiate()
		get_tree().root.add_child(pineapple)
		var random_pos_x := randf_range(-2.0, 2.0)
		var random_pos_z := randf_range(-2.0, 2.0)
		pineapple.global_position = global_position + Vector3(random_pos_x, 0, random_pos_z)
