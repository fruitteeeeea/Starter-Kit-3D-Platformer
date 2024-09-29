extends Camera3D

var TREE = preload("res://learnning/tree_2.tscn")

signal add_trauma_signal

var defult_zoom := 12.0 #等距相机的默认距离
var run_zoom := 15.0 #等距相机的奔跑距离
var zoom_tween : Tween

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		do_zoom(run_zoom)
	
	if event.is_action_released("mouse_right"):
		do_zoom(defult_zoom)

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
	
	if !raycast_result.is_empty():
		#var tree = TREE.instantiate()
		#tree.position = raycast_result["position"]
		#get_tree().root.add_child(tree)
		return raycast_result["position"]


func add_trauma(trauma_amount : float):
	add_trauma_signal.emit(trauma_amount)


func do_zoom(zoom01 : float = 15.0):
	if zoom_tween:
		zoom_tween.kill()
	
	zoom_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	zoom_tween.tween_property(self, "size", zoom01, 1.0)
