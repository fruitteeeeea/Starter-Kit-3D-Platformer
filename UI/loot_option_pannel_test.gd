extends PanelContainer

signal loot_option_selected (loot01)

var target : Node #修改目标
var property : String #修改属性

var loot : Loot

@onready var loot_rarity: Label = $MarginContainer/VBoxContainer/PanelContainer/LootRarity
@onready var tag_color: ColorRect = $MarginContainer/VBoxContainer/PanelContainer2/TagColor
@onready var loot_tag: Label = $MarginContainer/VBoxContainer/PanelContainer2/LootTag
@onready var rarity_color: ColorRect = $MarginContainer/VBoxContainer/PanelContainer/RarityColor
@onready var loot_porperty: Label = $MarginContainer/VBoxContainer/LootPorperty
@onready var loot_descrption: Label = $MarginContainer/VBoxContainer/LootDescrption

@onready var selected: PanelContainer = $Selected



func _ready() -> void:
	if !loot:
		return
	
	rarity_color.color = loot.rarity_color
	tag_color.color = loot.tag_color
	
	loot_rarity.text = loot.Rarity
	loot_tag.text = loot.Tag
	
	loot_porperty.text = loot.Property
	loot_descrption.text = loot.Description

func _on_button_button_up() -> void:
	selected.show()
	loot_option_selected.emit(loot)
	LootServer.select_loot(loot) #向 server 添加当前词条
