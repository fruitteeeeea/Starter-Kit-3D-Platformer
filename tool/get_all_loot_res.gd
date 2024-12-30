@tool
extends Node

func _run():
	FileServer.get_all_loots_tres()
	print(FileServer.loot_tres_info)
