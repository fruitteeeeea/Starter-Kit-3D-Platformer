extends Control

var defalt_posy := -900.0
var show_posy := 0.0

var move_tween : Tween

@export var LootOptionPannel : PackedScene #option 面板场景
@onready var loot_options: Control = $LootOptions

var current_loot_option := []
var current_loot_option_num := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = defalt_posy
	spwan_loot_pannel()


func move_pannel(posy01 := defalt_posy):
	if move_tween:
		move_tween.kill()
	
	move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self, "position:y", posy01, .5)

#出现选择的词条
func spwan_loot_pannel():
	for i in range(3): #生成 3 个 option 面板
		var loot_opption_pannel = LootOptionPannel.instantiate()
		loot_opption_pannel.loot_manager = self
		current_loot_option.append(loot_opption_pannel)
		current_loot_option_num += 1
		loot_options.add_child(loot_opption_pannel)



#选择了一个奖赏
func loot_be_selected(pannel01 : PanelContainer = null):
	#首先 先增加对应属性
	#manager.add...
	
	#视觉效果
	var tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(pannel01, "position:y", position.y + 20.0, .3)
	tween.tween_property(pannel01, "modulate:a", 0.0, .3)
	current_loot_option_num -= 1
	print(current_loot_option_num)

	if current_loot_option_num == 0:
		for i in current_loot_option:
			print(current_loot_option)
			current_loot_option.erase(i)
			i.queue_free()
		
		
		#spwan_loot_pannel()

	


func _on_button_pressed() -> void:
	loot_be_selected()
	pass # Replace with function body.
