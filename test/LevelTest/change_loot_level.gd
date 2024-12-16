extends Node
#在此更改战利品的等级

@export_enum("Level1Loot", "Level2Loot", "Level3Loot") var loot_level := "Level1Loot"

func do_stuff():
	LootServer.round_loots_nb = 5
	LootServer.round_loots_page = 5
	LootServer.current_loot_level = loot_level
