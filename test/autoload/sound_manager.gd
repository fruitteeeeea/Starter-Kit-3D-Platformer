extends Node

@onready var sfx: Node = $SFX

func play_sfx(name : String, do_random := false) -> void:
	if do_random:
		await get_tree().create_timer(randf_range(.1, .2)).timeout
	
	var player := sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	
	player.play()
