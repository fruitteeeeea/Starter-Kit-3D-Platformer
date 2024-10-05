extends CanvasLayer

var player : CharacterBody3D

func _on_coin_collected(coins):
	
	$Coins.text = str(coins)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if player:
		$PlayeStates/Speed.text = str(player.movement_speed)
