extends Camera3D

signal add_trauma_signal

#相机 tween 相关
var defult_zoom := 10.0 #等距相机的默认距离
var run_zoom := 12.0 #等距相机的奔跑距离
var run_tween_time := 1.0 #等距相机奔跑 tween 执行时间
var defult_tween_time := 5.0 #等距相机默认 tween 执行时间
var zoom_tween : Tween

var is_special_zoom := false #是否处于特殊缩放中
var special_zoom_tween : Tween

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
		return raycast_result["position"] #返回鼠标位置


func add_trauma(trauma_amount : float):
	add_trauma_signal.emit(trauma_amount)


func do_zoom(zoom01 : float = 15.0, time01 : float = defult_tween_time):
	if is_special_zoom: #如果被场景控制缩放 则跳过
		return

	if zoom_tween:
		zoom_tween.kill()
	
	zoom_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	zoom_tween.tween_property(self, "size", zoom01, time01)


func do_special_zoom(zoom01 : float = defult_zoom, is_special := false):
	if special_zoom_tween:
		special_zoom_tween.kill()
	
	special_zoom_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	special_zoom_tween.tween_property(self, "size", zoom01, .8)
	
	is_special_zoom = is_special
