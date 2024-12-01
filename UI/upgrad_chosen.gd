extends Control
#这个场景专心处理词条展示相关事务
#不自己创建参数 直接操作 server 的数组
#建议每次都是重新加载 以避免奇奇怪怪的问题

@onready var loot_list: HBoxContainer = %LootList

@onready var loot_number: Label = $PanelContainer/MarginContainer/VBoxContainer/Title/LootNumber
@onready var page_number: Label = $NextPage/MarginContainer/VBoxContainer/Title/PageNumber

@export var LootOptionPanel : PackedScene #词条

#实时更新 UI 信息
func _process(delta: float) -> void:
	#当前已选择的loot数量和当前回合可选择loot数量
	loot_number.text = str(LootServer.current_selected_loot.size()) + "/" + str(LootServer.round_loots_nb)
	if LootServer.current_selected_loot.size() == LootServer.round_loots_nb:
		close_panel()
	
	#当前已选择的loot页数和当前回合可选择loot页数
	page_number.text = str(LootServer.current_loot_page) + "/" + str(LootServer.round_loots_page)
	if LootServer.current_loot_page == LootServer.round_loots_page or\
	LootServer.current_selected_loot.size() == LootServer.round_loots_nb: #当前页面已经达到最大页数
		%NextPage.hide()
		%Done.show()

#根据server的挑选词条按顺序生成
func add_loot_option_panel(number01 : int = LootServer.loot_nb_page):
	#if LootServer.current_picked_loot.size() < LootServer.loot_nb_page:
		#print("当前挑选词条数不足以生成新的页面")
		#return
	
	for i in number01: #根据每页数量生成词条
		var loot01 = LootServer.current_picked_loot[0] #挑选词条数组中的第一个元素
		var loot_panel = LootOptionPanel.instantiate()
		loot_panel.loot = loot01
		loot_list.add_child(loot_panel)
		LootServer.current_picked_loot.erase(loot01)

func _on_next_page_pressed() -> void:
	LootServer.current_loot_page += 1
	for i in loot_list.get_children(): #更新一下词条
		i.queue_free()
	
	add_loot_option_panel()


func close_panel():
	LootServer.apply_modify()
	queue_free()

#完成
func _on_done_pressed() -> void:
	close_panel()
