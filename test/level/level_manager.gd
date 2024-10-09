extends Node

signal battel_begain
signal battel_finished
signal add_combo_signal

@onready var state_timer: Timer = $StateTimer

#获取关卡尺寸
@export var LevelSizeTopLeft : Marker3D
@export var LevelSizeDownRight : Marker3D
var level_pos_h : Vector2
var level_pos_v : Vector2

#枚举游戏阶段
enum Phase {
	SHOPPING,
	COUNTDOWN,
	BATTLE,
	REWARD
}

#游戏阶段应该是：购物-倒计时-战斗-奖励 这样的循环

@export var shopping_time := INF #购物时间无限 只有点了下一步才能接着继续
@export var battle_time := 60.0 #战斗时间是60秒
@export var count_time := 5.0 #冷却时间是5秒

@export var bgm : AudioStream

func _ready() -> void:
	if LevelSizeTopLeft && LevelSizeDownRight:
		level_pos_h = Vector2(LevelSizeTopLeft.global_position.x, LevelSizeDownRight.global_position.x)
		level_pos_v = Vector2(LevelSizeTopLeft.global_position.z, LevelSizeDownRight.global_position.z)
	pass


func level_manager():
	pass

func state01(): #五秒预备阶段
	if bgm:
		SoundManager.play_bgm(bgm) #播放背景音乐
	
	#await get_tree().create_timer(5).timeout
	battel_begain.emit()
	state02()

func state02():
	var battle_time := bgm.get_length()
	await get_tree().create_timer(battle_time - 5.0).timeout
	battel_finished.emit()

func add_combo():
	add_combo_signal.emit()


func _on_battle_zone_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		state01()