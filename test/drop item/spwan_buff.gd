extends Node

@onready var normal_item_spwaner: Marker3D = $"../NormalItemSpwaner"

func do_stuff():
	normal_item_spwaner.spwan_normal_item()
