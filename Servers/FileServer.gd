extends Node
#记录所有游戏文件的位置

#====关卡==== #所有关卡位于 Unit/Level 下的对应等级文件夹中
#普通关卡 
var normal_level_dir := "res://Unit/Level/NormalLevelScene/" #Level文件夹目录 #TDDO迁移到文件服务器

#特殊关卡
var title_level_scene := "res://Unit/Level/SpecialLevelScene/TitleScene.tscn" #标题场景
var ready_level_scene := "res://Unit/Level/SpecialLevelScene/ReadyLevel.tscn" #准备关卡
var shop_level_scene := "res://Unit/Level/SpecialLevelScene/ShopLevel.tscn" #商店关卡
var final_level_scene := "res://Unit/Level/SpecialLevelScene/CompleteLevel.tscn" #最终关卡

#默认关卡info
var defult_level_info := "res://Unit/Level/NormalLevelScene/0/00.tres" #默认的关卡信息

#====战利品==== #所有关于战利品的都存放在Unit/Loots/ 下的对应等级文件中 #记得使用load
var loot_tres := [ #战利品资源文件 #扫描在这几个位置 扫描出来的战利品放进字典里
	"res://Unit/Loots/Loot/Enemy/",
	"res://Unit/Loots/Loot/Payload/",
	"res://Unit/Loots/Loot/Player/",
	"res://Unit/Loots/Loot/Weapon/"
]
var loot_tres_info := { 0 : [], 1 : [], 2 : [], 3 : [] } #所有战利品资源文件的信息

func _ready() -> void:
	get_all_loots_tres()

#获取所有的 loot 资源文件 #TODO 在游戏开始前获取所有资源文件
func get_all_loots_tres(): 
	for i in loot_tres:
		var dir = DirAccess.open(i)
		
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.begins_with("0") && file_name.ends_with(".tres"):
				loot_tres_info[0].append(load(i.path_join(file_name)))
			if file_name.begins_with("1") && file_name.ends_with(".tres"):
				loot_tres_info[1].append(load(i.path_join(file_name)))
			elif file_name.begins_with("2") && file_name.ends_with(".tres"):
				loot_tres_info[2].append(load(i.path_join(file_name)))
			elif file_name.begins_with("3") && file_name.ends_with(".tres"):
				loot_tres_info[3].append(load(i.path_join(file_name)))
			file_name = dir.get_next()
		dir.list_dir_end() #结束遍历
	
	print("已获取所有 loot 资源信息", loot_tres_info) #扫描出所有符合要求的loot资源文件

#获取关卡场景实例
func get_next_level_scene(leve_info01 : LevelInfo): #总是获取下一个关卡场景
	var next_level = leve_info01.level_level + 1

	var result_level_scene := [] #关卡实例 #扫描出来的关卡场景
	var result_level_tres := [] #关卡信息 #扫描出来的关卡信息
	var target_folder_path = normal_level_dir.path_join(str(next_level)) #打开对应关卡文件夹
	
	var dir = DirAccess.open(target_folder_path) #打开目标文件夹
	
	dir.list_dir_begin() #遍历目标文件夹中的所有文件
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"): # 筛选以 .tscn 结尾的文件
			result_level_scene.append(target_folder_path.path_join(file_name)) #加入到关卡实例数组中
		elif file_name.ends_with(".tres"): # 筛选以 .tres 结尾的文件
			result_level_tres.append(target_folder_path.path_join(file_name)) #加入到关卡资源数组中
		file_name = dir.get_next()
	dir.list_dir_end() #结束遍历
	print(["关卡实例", result_level_scene, "关卡信息", result_level_tres]) #扫描出所有符合要求的关卡场景文件
	
	var final_scene = result_level_scene.pick_random() #得出最终关卡场景
	var final_tres = result_level_tres.pick_random() #得出最终关卡信息
	
	return [final_scene, final_tres] #返回关卡场景和关卡信息


#获取特定的战利品资源 #战利品类型 #战利品等级
func get_specific_loot(loot_type : String, loot_level : int):
	pass

#获取特定的商品
func get_specific_item():
	pass
