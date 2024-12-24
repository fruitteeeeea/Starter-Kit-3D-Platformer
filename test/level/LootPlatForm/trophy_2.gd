extends Node3D

var time := 0.0

func _process(delta):
	
	rotate_y(2 * delta) # Rotation
	position.y += (cos(time * 5) * 1) * delta # Sine movement
	
	time += delta


func _on_area_3d_body_entered(body: Node3D) -> void: #玩家触碰最终奖杯
	Hud.level_massage.show_massage("已完成本轮游戏！", "即将返回主菜单")
	await get_tree().create_timer(2.0).timeout
	LevelServer.level_info = load(FileServer.defult_level_info) #重置一下关卡信息
	LevelServer.change_scene(FileServer.title_level_scene)
