extends Node3D
#一个基础的关卡包括 :环境光照 地图
#Payload及线路 Debuff数量 额外目标数量 刷怪数量 刷怪强度 动态难度
#任务时间

@export var world_envi : Environment #世界环境
@export var level_map : GridMap #关卡地图

@onready var path_3d: Path3D = $Path3D

@onready var entery_point: Marker3D = $EnteryPoint #初始地点
@onready var entery_area: Area3D = $EnteryPoint/EnteryArea #关卡起始区域

@onready var level_timer: Timer = $LevelTimer #关卡计时器
@onready var basic_player: CharacterBody3D = $"Basic Player" #玩家节点

@export var level_info : LevelInfo #$加载关卡资源

#更新关卡状态
func _ready() -> void: 
	print(level_info.level_level) #打印关卡名字
	level_timer.wait_time = level_info.level_time #更新计时器时间
	path_3d.curve = level_info.payload_path #更换对应 path3d 资源
	
	add_enemy_spwaner()
	add_debuff_spwaner()
	
	SoundManager.play_bgm(level_info.level_BGM) #播放关卡 BGM
	
	LootServer.update_loot_level(level_info.level_loot_level) #更新关卡战利品等级
	LootServer.update_shop_level(level_info.level_shop_level) #更新关卡商品等级
	
	entery_area.area_exited.connect(level_start) #离开黄圈 关卡开始
	level_timer.timeout.connect(level_complete) #计时器完成 关卡结束


func add_enemy_spwaner(): #生成敌人生成器节点
	pass


func add_debuff_spwaner(): #添加 debuff 生成节点
	pass


func update_player(pos: Vector3): #关卡文件会更新玩家节点
	$"Basic Player".global_position = pos

#所有关卡处理逻辑在LevelServel中进行
func level_start():
	pass


func level_complete():
	pass
