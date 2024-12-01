extends PanelContainer

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	LootServer.loot_status_update.connect(_on_info_update)

func _on_info_update():
	label.text = "Loot : " + str(LootServer.round_loots_nb) + "/" + str(LootServer.round_loots_page)
