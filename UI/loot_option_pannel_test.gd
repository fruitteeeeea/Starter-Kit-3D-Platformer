extends PanelContainer

var loot_manager : Node #节点管理器
@onready var loot_option_pannel: PanelContainer = $"." #选项本身
@onready var selected: PanelContainer = $Selected


var target : Node #修改目标
var property : String #修改属性

@onready var loot_name: Label = $MarginContainer/VBoxContainer/LootName
@onready var loot_tag: Label = $MarginContainer/VBoxContainer/PanelContainer2/LootTag
@onready var loot_porperty: Label = $MarginContainer/VBoxContainer/LootPorperty
@onready var loot_descrption: Label = $MarginContainer/VBoxContainer/LootDescrption

var loot : Loot

func _ready() -> void:
	#设定好标签属性
	loot_name.text = loot.loot_name
	loot_tag.text = loot.loot_tag
	loot_porperty.text = loot.loot_porperty
	loot_descrption.text = loot.loot_descrption

func _on_button_button_up() -> void:
	selected.show()
	LootServer.select_loot(loot) #向 server 添加当前词条
