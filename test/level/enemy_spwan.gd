extends Marker3D

var Enemy := preload("res://test/enemy/enemy_skeleton.tscn")
var rand_range := 10.0


@export var do_spwan_enemy := false
@export var spwan_enemy_number := 1
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !do_spwan_enemy:
		timer.stop()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	spwan_enemy()
	pass # Replace with function body.


func spwan_enemy():
	for i in range(spwan_enemy_number):
		var enemy = Enemy.instantiate()
		get_tree().root.add_child(enemy)
		enemy.global_position = global_position + Vector3(randf_range(-rand_range, rand_range), 0, randf_range(-rand_range, rand_range))
