extends Node
#所有关卡位于 Unit/Level 下的对应等级文件夹中

var final_level := 3 #最后一关是第3关 最后一关结束之后不会被传送到商店 而是通关关卡

@export var level_dir := "res://Unit/Level/LevelScene/" #Level文件夹目录 

#特殊关卡
var ready_level_scene := "res://Unit/Level/ReadyLevel.tscn"
var shop_level_scene := "res://Unit/Level/ShopLevel.tscn" #商店关卡
var final_level_scene := "res://Unit/Level/CompleteLevel.tscn" #最终关卡

@export var level_info : LevelInfo

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug"):
		#get_level_scene()

#更换场景
func change_scene(path: String): #专门用于处理游戏场景切换
	var tree := get_tree()
	
	tree.change_scene_to_file(path)
	await tree.tree_changed #等待游戏场景切换
	
	for node in tree.get_nodes_in_group("entry_points"): #移动玩家至关卡出生点
		tree.current_scene.update_player(node.global_position)
		break

#前往购物关卡或结算关卡
func change_to_shop_level():
	var next_level = level_info.level_level + 1
	if next_level <= final_level:
		change_scene(shop_level_scene) #在这个位置判断是否还有最后一关
	else:
		change_scene(final_level_scene)

#前往下个游戏关卡
func change_to_next_level():
	var level_scene01 = get_level_scene()[0] #获取下一个关卡的地址
	var level_info01 = get_level_scene()[1] #获取下一个关卡的关卡信息
	
	level_info = level_info01 #更新关卡信息
	change_scene(level_scene01) #更换关卡场景

#获取关卡场景实例
func get_level_scene(): #总是获取下一个关卡场景
	var next_level = level_info.level_level + 1

	var result_level_scene := [] #关卡实例 #扫描出来的关卡场景
	var result_level_tres := [] #关卡信息 #扫描出来的关卡信息
	var target_folder_path = level_dir.path_join(str(next_level)) #打开对应关卡文件夹
	
	var dir = DirAccess.open(target_folder_path) #打开目标文件夹
	
	dir.list_dir_begin() #遍历目标文件夹中的所有文件
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"): # 筛选以 .tscn 结尾的文件
			result_level_scene.append(target_folder_path.path_join(file_name)) #加入到关卡实例数组中
		elif file_name.ends_with(".tres"): # 筛选以 .tscn 结尾的文件
			result_level_tres.append(target_folder_path.path_join(file_name)) #加入到关卡资源数组中
		file_name = dir.get_next()
	dir.list_dir_end() #结束遍历
	print(["关卡实例", result_level_scene, "关卡信息", result_level_tres]) #扫描出所有符合要求的关卡场景文件
	
	var final_scene = result_level_scene.pick_random() #得出最终关卡场景
	var final_tres = result_level_tres.pick_random() #得出最终关卡信息
	
	return [final_scene, final_tres] #返回关卡场景和关卡信息
