extends Node3D
#一个基础的关卡包括 :环境光照 地图
#Payload及线路 Debuff数量 额外目标数量 刷怪数量 刷怪强度 动态难度
#任务时间

@export var world_envi : Environment #世界环境
@export var level_map : GridMap #关卡地图

@onready var path_3d: Path3D = $Path3D

@onready var entery_point: Area3D = $EnteryPoint #初始地点
@onready var enter_shop_level_button: Node3D = $EnterShopLevelButton #离开地点


@onready var level_timer: Timer = $LevelTimer #关卡计时器
@onready var basic_player: CharacterBody3D = $"Basic Player" #玩家节点

var level_info : LevelInfo #$加载关卡资源

@onready var spwan_object: Node = $SpwanObject
 #所有生成物放在这里

#更新关卡状态
func _ready() -> void: 
	update_player(entery_point.global_position)
	level_info = LevelServer.level_info
	
	var massage = "关卡：" + str(level_info.level_level)
	Hud.level_massage.show_massage(massage, "请好好加油！") #欢迎页面

	LootServer.update_loot_level(level_info.level_loot_level) #更新关卡战利品等级
	LootServer.update_shop_level(level_info.level_shop_level) #更新关卡商品等级

	level_timer.wait_time = level_info.level_time #更新计时器时间
	path_3d.curve = level_info.payload_path #更换对应 path3d 资源
	
	add_spwaners()
	
	SoundManager.play_bgm(level_info.level_BGM) #播放关卡 BGM

	entery_point.area_exited.connect(level_start) #离开黄圈 关卡开始
	level_timer.timeout.connect(level_complete) #计时器完成 关卡结束

	LevelServer.level_complete_requirement_met.connect(level_complete)

#添加各类生成器
func add_spwaners(): 
	var main_level = get_tree().current_scene #直接加载在主场景下
	
	for spwaner in level_info.enemy_spwaner_list:
		EnemySpwanerServer.add_enemy_spwaner(spwaner) #敌人生成器服务器添加敌人生成节点
	
	for spwaner in level_info.level_chest_spwaner:
		var spwaner01 = spwaner.instantiate()
		main_level.add_child(spwaner01) #场景添加奖励箱子节点
	
	for spwaner in level_info.payload_debuff_list:
		var spwaner01 = spwaner.instantiate()
		main_level.add_child(spwaner01) #场景添加debuff 节点
	
	for target in level_info.payload_target_list:
		var target01 = target.instantiate()
		main_level.add_child(target01) #场景添加debuff 节点


func update_player(pos: Vector3): #关卡文件会更新玩家节点
	basic_player.global_position = pos

#所有关卡处理逻辑在LevelServel中进行
func level_start():
	pass


func level_complete():
	print("已完成关卡")
	#判断玩家是否完成关卡目标
	#否 玩家失败
	#是 玩家进入过渡层
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(enter_shop_level_button, "position:y", 0.0, .5)
	
	#展示战利品结算界面
	#展示商店？
	#关卡
	pass

#玩家离开区域 关卡开始
func _on_entery_point_body_exited(body: Node3D) -> void:
	entery_point.queue_free()
