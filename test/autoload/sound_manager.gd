extends Node

@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer

@export var rand_factor := 1.0

#播放 音效
func play_sfx(name : String, do_random := false) -> void:
	if do_random:
		await get_tree().create_timer(randf_range(.1, .2) * rand_factor).timeout
	
	var player := sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	
	player.play()

#播放 BGM
func play_bgm(stream : AudioStream) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	
	bgm_player.stream = stream
	bgm_player.play()
