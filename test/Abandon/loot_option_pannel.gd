extends PanelContainer

@onready var loot_option_pannel: PanelContainer = $"." #选项本身
var loot_manager : Node #节点管理器

var target : Node #修改目标
var property : String #修改属性

func _on_button_button_up() -> void:
	if loot_manager:
		loot_manager.loot_be_selected(self)