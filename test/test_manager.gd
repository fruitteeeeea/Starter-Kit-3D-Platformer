extends Control

@export var SMG : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	var bomb_shooter = load("res://Unit/Weapon/basic_weapon.tscn") as PackedScene
	WeaponServers.add_weapon(bomb_shooter)


func _on_add_1_xenemy_pressed() -> void:
	var spwaner = EnemyStatusServer.enemy_spwaner.pick_random() #随机选择一个来生成敌人
	EnemyStatusServer.add_enemy(spwaner)
	$HBoxContainer/VBoxContainer2/add1xenemy.focus_mode = Control.FOCUS_NONE
