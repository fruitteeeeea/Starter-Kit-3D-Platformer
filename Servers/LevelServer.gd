extends Node
#所有关卡位于 Unit/Level 下的对应等级文件夹中

var level_information := {
	"level_time" : 0.0, #关卡时间
	
	"level_loot_nb" : 0, #关卡战利品数量
	"levbel_debuff_nb" : 0, #关卡中debuff的数量
	"level_target_nb" : 0, #关卡中任务目标数
	"level_target_pool" : [], #任务目标池子
	
	"enemy_spwaner" : 0, #怪物生成点数量
	"enemy_spwan_point_pool" : [], #怪物生成点池子
	
	#"enemy_spwaner_posy" : 0.0, #怪物生成y 坐标
	#"enemy_spwaner_pos_limit" : [], #怪物生成坐标限制

	"enemy_power" : 0.0, #怪物强度
	
	"dynamic_difficulty" : false #动态难度
}

@export var level_time := 45.0 #任务时间
@export var enemy_spwaner : Array[PackedScene] #怪物生成器


@onready var level_timer: Timer = $LevelTimer

@export var level_list := [
	"res://test/LevelTest/prototype_test.tscn"
	
]

var LevelList := [] #任务列表

@export var level_dir := "res://Unit/Level/" #Level文件夹目录 
@export_enum("Level01", "Level02", "Level03") var next_level := "Level01" #下一个关卡的品质

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		change_scene(level_list.pick_random())

#更换场景
func change_scene(path: String): #专门用于处理游戏场景切换
	var tree := get_tree()
	
	tree.change_scene_to_file(path)
	await  tree.tree_changed #等待游戏场景切换
	
	for node in tree.get_nodes_in_group("entry_points"): #移动玩家至关卡出生点
		tree.current_scene.update_player(node.global_position)
		break

#更换关卡
func change_level():
	var next_level01 = next_level
	var level_file = get_level_files(next_level01).pick_random() #随机选择对应关卡的场景文件
	print("已选择关卡", level_file)
	change_scene(level_file)

#获取下一个关卡的 tscn 场景文件场景数组
func get_level_files(subfolder_name := "Level01") -> Array:
	var result_files := [] #用于存储匹配的文件夹
	var target_folder_path = level_dir.path_join(subfolder_name)
	
	var dir = DirAccess.open(target_folder_path) #打开目标文件夹
	
	dir.list_dir_begin() #遍历目标文件夹中的所有文件
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"): # 筛选以 .tscn 结尾的文件
			result_files.append(target_folder_path.path_join(file_name)) #加入到结果数组中
		file_name = dir.get_next()
	dir.list_dir_end() #结束遍历
	print("目标关卡列表", result_files)
	
	return result_files #返回结果场景数组

#关卡开始 #离开区域以开始游戏
func level_start():
	#启动刷怪点
	for spwaner in level_information["enemy_spwan_point_pool"]:
		EnemySpwanerServer.add_enemy_spwaner(spwaner)
		pass

	#启动任务目标
	for target in level_information["level_target_pool"]:
		LevelTargetServer.add_level_target(target)
	
	#启动 debuff 生成
	

	#启动机计时器
	level_timer.wait_time = level_information["level_time"]
	level_timer.start()

#关卡完成
func level_complete():
	#判断玩家是否完成关卡目标
	#否 玩家失败
	#是 玩家进入过渡层
	
	#展示战利品结算界面
	#展示商店？
	
	#关卡
	pass


func _on_level_timer_timeout() -> void:
	level_complete()
