extends Area3D

@export_enum("Enemy", "Player") var aoe_type := "Enemy" #AOE作用对象
@export var mesh_color : Array[Color]

@export var aoe_range := 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var mesh: MeshInstance3D = $Mesh

var display_tween : Tween
var init_scale := Vector3.ONE

func _ready() -> void:
	mesh.material_override.albedo_color = mesh_color.pick_random()
	scale *= randf_range(4.0, 5.8)
	animation_player.play("01")
	await get_tree().create_timer(.2).timeout
	animation_player.play("02")
	await get_tree().create_timer(.5).timeout
	
	
	animation_player.play_backwards("01")
	await animation_player.animation_finished
	queue_free()

#显示的动画 
func do_display_tween(trans01 := 1.0, scale01 := .2):
	if display_tween:
		display_tween.kill()
	
	display_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	display_tween.tween_property(mesh, "transparency", trans01, .5)
	display_tween.tween_property(mesh, "scale", init_scale *  scale01, .5)

#作用方法
func do_staff():
	for i in get_overlapping_bodies():
		print("作用1个物体")
