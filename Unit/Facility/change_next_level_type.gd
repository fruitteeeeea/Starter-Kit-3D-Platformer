extends Node
#在此更改下一个加载关卡的等级

@export_enum("Level01", "Level02", "Level03") var next_level := "Level01" #下一个关卡的品质

func do_stuff():
	LevelServer.next_level = next_level
