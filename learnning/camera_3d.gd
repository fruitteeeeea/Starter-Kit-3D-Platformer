extends Camera3D

var TREE = preload("res://learnning/tree_2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		shoot_ray()


func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	
	var raycast_result = space.intersect_ray(ray_query)
	print(raycast_result)
	
	if !raycast_result.is_empty():
		var tree = TREE.instantiate()
		tree.position = raycast_result["position"]
		get_tree().root.add_child(tree)
		
