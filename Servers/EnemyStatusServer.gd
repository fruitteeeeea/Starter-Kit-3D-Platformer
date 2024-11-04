extends Node

var enemy_in_scene := [] #当前场景存在的敌人
var enemy_spwaner_marker := [] #当前场景存在的敌人生成位置

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_enemy():
	if !enemy_spwaner_marker: #如果没有 marker 的话 那就没事儿了
		return
	
	var current_spwaner = enemy_spwaner_marker.pick_random() #随机选择一个数组
	var current_enemy = current_spwaner.enemy_scene.pick_random() #随机选择该数组中的一个敌人 
	
	var enemy = current_enemy.instantiate() #生成敌人
	get_tree().root.add_child(enemy)
	
	enemy.global_position = current_spwaner.global_position + \
	Vector3(randf_range(-current_spwaner.rand_range, current_spwaner.rand_range), 0, randf_range(-current_spwaner.rand_range, current_spwaner.rand_range)) #随机位置

func remove_enemy():
	pass
