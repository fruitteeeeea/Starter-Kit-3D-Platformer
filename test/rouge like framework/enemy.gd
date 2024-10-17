extends Control

@export var Player : Node

@onready var timer: Timer = $Timer #3秒计算一次DPS
var damage_arry := []

@onready var dps_number_label: Label = $HBoxContainer/DPSNumberLabel
var dps_number := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func deal_damage(): #造成伤害
	pass


func take_damage(damage01 : float): #接受伤害
	damage_arry.append(damage01)


func _on_timer_timeout() -> void:
	#if damage_arry.is_empty():
		#return
	
	#结算DPS
	var total_damage = 0.0
	for num in damage_arry:
		total_damage += num
	
	dps_number = total_damage
	dps_number_label.text = str(dps_number)
	damage_arry.clear() #执行完成后清空数组
