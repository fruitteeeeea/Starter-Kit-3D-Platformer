extends Node3D

@onready var animation_player: AnimationPlayer = $"button-floor-square2/AnimationPlayer"

#按钮标识
@export var text : String
@onready var label_3d: Label3D = $Label3D

#按钮方法
@onready var method: Node3D = $Method
var todo_list := [] #即将要执行的方法

func _ready() -> void:
	label_3d.text = text
	for i in method.get_children():
		todo_list.append(i) #将所有方法子节点加入到数组中

func _on_area_3d_body_entered(body: Node3D) -> void:
	animation_player.play("toggle-on")
	for i in todo_list:
		if i.has_method("do_stuff"):
			i.do_stuff()


func _on_area_3d_body_exited(body: Node3D) -> void:
	animation_player.play("toggle-off")
