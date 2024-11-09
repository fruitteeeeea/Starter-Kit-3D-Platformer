extends Control

@onready var label_occupy_zone: Label = $VBoxContainer/OccupyZone/HBoxContainer/LabelOccupyZone
@onready var progress_bar_occupy_zone: ProgressBar = $VBoxContainer/OccupyZone/HBoxContainer/ProgressBarOccupyZone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if LevelTargetServer.current_occupy_zone_node:
		var zone = LevelTargetServer.current_occupy_zone_node[0]
		progress_bar_occupy_zone.max_value = LevelTargetServer.current_occupy_zone[zone][1]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LevelTargetServer.current_occupy_zone_node: #根据占领时间计算出进度条占比
		progress_bar_occupy_zone.value = LevelTargetServer.current_occupy_zone[LevelTargetServer.current_occupy_zone_node[0]][0]
	pass
