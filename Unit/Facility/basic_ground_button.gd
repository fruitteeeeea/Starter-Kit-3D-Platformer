extends Node3D

@onready var animation_player: AnimationPlayer = $"button-floor-square2/AnimationPlayer"

#按钮标识
@onready var label_3d: Label3D = $Label3D

#按钮方法
@onready var method: Node3D = $Method
var todo_list := [] #即将要执行的方法

func _ready() -> void:
	for i in method.get_children():
		todo_list.append(i) #将所有方法子节点加入到数组中

#执行进入按钮后的方法
func _on_area_3d_body_entered(body: Node3D) -> void:
	animation_player.play("toggle-on")
	for i in todo_list:
		if i.has_method("do_stuff"):
			i.do_stuff()

#执行离开按钮后的方法
func _on_area_3d_body_exited(body: Node3D) -> void:
	animation_player.play("toggle-off")
	for i in todo_list:
		if i.has_method("unddo_stuff"):
			i.unddo_stuff()
