extends Control

@export var MerchanOptionPannel : PackedScene #商品 面板场景
@onready var merchan_options: Control = $MerchanOptions

var current_merchan_option := []
var current_merchan_option_num := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spwan_loot_pannel(): 
	for i in range(3): #生成 3 个 option 面板
		var merchan_opption_pannel = MerchanOptionPannel.instantiate()
		merchan_opption_pannel.loot_manager = self
		current_merchan_option.append(merchan_opption_pannel)
		current_merchan_option_num += 1
		merchan_options.add_child(merchan_opption_pannel)
