extends Control

@export var BuffIcon : PackedScene #buff 图标

var maximum_buff := 5 #最大buff数
var cureent_bufflist := [] #当前buff数量

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		add_bufficon()
	if event.is_action_pressed("debug2"):
		remove_bufficon()

#添加buff图标
func add_bufficon():
	if cureent_bufflist.size() >= maximum_buff:
		return
	
	var bufficon = BuffIcon.instantiate()
	h_box_container.add_child(bufficon)
	cureent_bufflist.append(bufficon)
	pass

#减少buff图标
func remove_bufficon():
	if !cureent_bufflist:
		return
	
	var icon = cureent_bufflist[0]
	icon.queue_free()
	cureent_bufflist.erase(icon)
