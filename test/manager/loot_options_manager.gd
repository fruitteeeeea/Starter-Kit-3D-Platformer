extends Node

@export var level_manager : Node #关卡管理器
@export var UIScene : PackedScene #UI内容

func show_ui():
	if level_manager:
		var ui_scene = UIScene.instantiate()
		level_manager.UI_Container.add_child(ui_scene)
