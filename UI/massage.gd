extends Control

@onready var label: Label = $MarginContainer/PanelContainer/MarginContainer/Label

func show_massage(massage01 : String):
	label.text = massage01
	show()

func hide_massage():
	label.text = ""
	hide()
