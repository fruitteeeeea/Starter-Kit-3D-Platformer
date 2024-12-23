extends Control

@export var SMG : PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		pass

func _on_clean_player_weapon_pressed() -> void:
	WeaponServers.remove_weapon()


func _on_smg_pressed() -> void:
	var smg = load("res://Unit/Weapon/BulletShooter/smg.tscn") as PackedScene
	WeaponServers.add_weapon(smg)


func _on_shotgun_pressed() -> void:
	var shotgun = load("res://Unit/Weapon/BulletShooter/shotgun.tscn") as PackedScene
	WeaponServers.add_weapon(shotgun)


func _on_reolver_pressed() -> void:
	var reolver = load("res://Unit/Weapon/BulletShooter/revolver.tscn") as PackedScene
	WeaponServers.add_weapon(reolver)


func _on_slugger_pressed() -> void:
	var slugger = load("res://Unit/Weapon/BulletShooter/slugger.tscn") as PackedScene
	WeaponServers.add_weapon(slugger)


func _on_bomb_shooter_pressed() -> void:
	var bomb_shooter = load("res://Unit/Weapon/basic_bomb_weapon.tscn") as PackedScene
	WeaponServers.add_weapon(bomb_shooter)


func _on_add_loot_pressed() -> void:
	LootServer.update_loot_status(1)
	$"HBoxContainer/VBoxContainer3/add loot".focus_mode = Control.FOCUS_NONE
