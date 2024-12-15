extends Control

@onready var massage: Label = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/Massage
@onready var description: Label = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/Description

func show_massage(massage01 : String, des01 : String):
	massage.text = massage01
	description.text = des01
	show()
	await get_tree().create_timer(5.0).timeout
	hide_massage()

func hide_massage():
	massage.text = ""
	description.text = ""
	hide()
