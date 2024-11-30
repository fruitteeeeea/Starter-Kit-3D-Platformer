extends Control
#这个场景专心处理词条展示相关事务
#不自己创建参数 直接操作 server 的数组
#建议每次都是重新加载 以避免奇奇怪怪的问题

@onready var loot_list: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/LootList

@onready var loot_number: Label = $PanelContainer/MarginContainer/VBoxContainer/Title/LootNumber
@onready var page_number: Label = $NextPage/MarginContainer/VBoxContainer/Title/PageNumber

#实时更新 UI 信息
func _process(delta: float) -> void:
	loot_number.text = str(LootServer.current_selected_loot.size()) + "/" + str(LootServer.current_picked_loot.size())

#func _ready() -> void:
	#for i in range(3): #生成最初的三个词条
		#var loot = LootServer.current_picked_loot[0]
		



func _on_next_page_pressed() -> void:
	
	for i in loot_list.get_children(): #更新一下词条
		i.queue_free()

#关闭页面 
func _on_close_pressed() -> void:
	queue_free()


func _on_done_pressed() -> void:
	queue_free()
