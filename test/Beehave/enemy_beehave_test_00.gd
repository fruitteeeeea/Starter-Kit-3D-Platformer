extends CharacterBody3D

@onready var blackboard: Blackboard = $Blackboard

var max_health := 3.0 #最大生命值 
var current_helath := 0.0 #当前生命值

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	blackboard.set_value("player_close", false) #玩家是否接近

func pickrandom_pos() -> Vector3:
	var randompos = Vector3(randf_range(-2, 2), 0, randf_range(-2, 2))
	return global_position + randompos

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_detecte_player_body_entered(body: Node3D) -> void:
	blackboard.set_value("player_close", true)


func _on_detecte_player_body_exited(body: Node3D) -> void:
	blackboard.set_value("player_close", false)
