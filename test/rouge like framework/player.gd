extends Control

@export var Attribute := {
	"攻击速度" : 1.2,
	"攻击伤害" : 10.0,
	"移动速度" : 30.0,
	"跳跃高度" : 20.0
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func deal_damage(): #造成伤害
	pass


func take_damage(): #接受伤害
	pass
