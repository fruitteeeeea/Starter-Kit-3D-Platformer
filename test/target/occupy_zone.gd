extends Node3D
#占领区域的节点

@export var occupy_time_factor := 1.0 #占领速率
@export var complete_occupy_time := 10.0 #最大占领时间

var player_enter := false #玩家是否进入占领区域
var zone_occupy_time := 0.0 #当前占领时间

var first_time_finished := true
var time_accumulator := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelTargetServer.current_occupy_zone_node.append(self)
	LevelTargetServer.current_occupy_zone[self] = [zone_occupy_time, complete_occupy_time] #添加当前占领时间 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if zone_occupy_time >= complete_occupy_time:
		if first_time_finished:
			first_time_finished = false
			LevelTargetServer.complete_occupy_zone(self) #处理处理
		
		return
	
	if player_enter:
		time_accumulator += delta  # 累加时间

		# 每秒增加 1
		while time_accumulator >= 1.0:
			zone_occupy_time += 1.0  # 每秒增加 1
			time_accumulator -= 1.0  # 重置累积时间
		
		#zone_occupy_time += delta * occupy_time_factor
		#zone_occupy_time += 1.0
		LevelTargetServer.current_occupy_zone[self][0] = zone_occupy_time


func _on_area_3d_body_entered(body: Node3D) -> void:
	player_enter = true #玩家进入占领区域


func _on_area_3d_body_exited(body: Node3D) -> void:
	player_enter = false #玩家离开占领区域
