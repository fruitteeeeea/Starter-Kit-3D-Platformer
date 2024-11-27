extends CanvasLayer

@onready var buff_icon: HBoxContainer = $BuffIcon

var current_pauseUI : Control #当前的暂停菜单
var current_Bufficon : Control #当前Buff栏位

@onready var loot_panel_pos: Control = $LootPanelPos
var current_LootUI : Control #当前的战利品选择UI
