extends Node

@export var panel : Control

func do_stuff():
	if LootServer.round_loots_nb > 0:
		panel.show()

func unddo_stuff():
	panel.hide()
