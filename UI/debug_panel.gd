extends Control

@onready var line_edit: LineEdit = $ColorRect/HBoxContainer/LineEdit

#
@export var debug_info := {
	

}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug2"):
		get_viewport().set_input_as_handled()
		visible =! visible
		line_edit.grab_focus()
		line_edit.select_all()
		line_edit.clear()

func _on_line_edit_text_submitted(new_text: String) -> void:
	match new_text:
		"clear wseapon":
			WeaponServers.remove_weapon()
			print("清除玩家武器")
		"add shotgun":
			var shotgun = load("res://Unit/Weapon/BulletShooter/shotgun.tscn") as PackedScene
			WeaponServers.add_weapon(shotgun)
			print("玩家添加霰弹枪")
		"add bombshoter":
			var bomb_shooter = load("res://Unit/Weapon/basic_bomb_weapon.tscn") as PackedScene
			WeaponServers.add_weapon(bomb_shooter)
			print("玩家添加投弹器")
		"add loot":
			LootServer.update_loot_status(1)
			print("添加 1 个战利品")
		"add 10xloot":
			LootServer.update_loot_status(9, 3)
			print("添加 1 0 个战利品")
		_:
			print("未找到匹配方法")
			
	apply_debug_line()

#执行操作
func apply_debug_line():
	line_edit.text = ""
