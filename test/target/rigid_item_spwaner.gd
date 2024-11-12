extends Marker3D
#此处生成刚体掉落物 

@export var RigidItem : PackedScene #物品
@export var RigidItems : Array[PackedScene]
@export var spwan_time := 2.0 #掉落时间
@export var spwan_time_min := 1.0
@export var spwan_time_max := 3.0

var do_drop := true #是否掉落
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = spwan_time

func spwan_rigid_item():
	var item = RigidItems.pick_random().instantiate()
	get_tree().root.add_child(item)
	item.position = global_position 
	
	var random_x = randf_range(-1.0, 1.0)
	var random_z = randf_range(-1.0, 1.0)
	
	var direction = Vector3(random_x, 1, random_z).normalized() #刚体方向
	item.apply_central_force(direction * 700)
	
	var random_offset = Vector3(randf_range(-45, 45), 1, randf_range(-45, 45))
	item.rotation += random_offset 

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(spwan_time_min, spwan_time_max)
	if do_drop:
		spwan_rigid_item()
