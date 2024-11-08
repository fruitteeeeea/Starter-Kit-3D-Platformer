extends Control

@onready var label_occupy_zone: Label = $VBoxContainer/OccupyZone/HBoxContainer/LabelOccupyZone
@onready var progress_bar_occupy_zone: ProgressBar = $VBoxContainer/OccupyZone/HBoxContainer/ProgressBarOccupyZone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LevelTargetServer.current_occupy_zone:
		progress_bar_occupy_zone.value = 
	pass
