extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HBoxContainer2/PanelContainer/VBoxContainer/Label2.text = str(LootServer.current_picked_loot)
	$HBoxContainer2/PanelContainer2/VBoxContainer/Label4.text = str(LootServer.current_selected_loot)


func _on_add_10x_loot_pressed() -> void:
	LootServer.add_loots(LootServer.level_1_loot_list, 3)


func _on_random_pick_loot_pressed() -> void:
	var selected_loot = LootServer.current_picked_loot.pick_random()
	LootServer.select_loot(selected_loot)


func _on_clear_picked_loot_pressed() -> void:
	LootServer.current_picked_loot.clear()


func _on_clear_selected_loot_pressed() -> void:
	LootServer.current_selected_loot.clear()


func _on_apply_selected_loot_pressed() -> void:
	LootServer.apply_modify()
