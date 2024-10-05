extends Node

signal battel_begain
signal battel_finished

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
	if bgm:
		SoundManager.play_bgm(bgm)
	
	state01()

func state01():
	await get_tree().create_timer(5).timeout
	battel_begain.emit()
	state02()

func state02():
	await get_tree().create_timer(60).timeout
	battel_finished.emit()
