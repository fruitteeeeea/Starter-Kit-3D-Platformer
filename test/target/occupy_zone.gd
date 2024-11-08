extends Node3D
#占领区域的节点

@export var occupy_time_factor := 1.0 #占领速率
@export var compelte_occupy_time := 10.0 #最大占领时间

var player_enter := false #玩家是否进入占领区域
var zone_occupy_time := 0.0 #当前占领时间

var first_time_finished := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelTargetServer.current_occupy_zone[self] = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if zone_occupy_time >= compelte_occupy_time:
		if first_time_finished:
			first_time_finished = false
			LevelTargetServer.complete_occupy_zone(self) #处理处理
		
		return
	
	if player_enter:
		zone_occupy_time += delta * occupy_time_factor
		LevelTargetServer.current_occupy_zone[self] = zone_occupy_time


func _on_area_3d_body_entered(body: Node3D) -> void:
	player_enter = true #玩家进入占领区域


func _on_area_3d_body_exited(body: Node3D) -> void:
	player_enter = false #玩家离开占领区域
