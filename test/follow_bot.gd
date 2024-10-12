extends Node3D

var player : CharacterBody3D
var follow_point : Marker3D

@onready var carrot_2: Node3D = $carrot2 #胡萝卜模型
@export var defult_posz := .311

var shoot_tween : Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player && follow_point:
		global_position = global_position.lerp(follow_point.global_position, .1) #后面是跟随速度

	rotation.y = lerp_angle(rotation.y, player.rotation_direction, delta * 25) #跟随人物转身速度


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("main_weapon"):
		bot_shoot()

func bot_shoot():
	if shoot_tween:
		shoot_tween.kill()
	
	shoot_tween = create_tween()
	shoot_tween.set_ease(Tween.EASE_OUT)
	shoot_tween.set_trans(Tween.TRANS_EXPO)
	shoot_tween.tween_property(carrot_2, "position:z", -defult_posz, .1)
	shoot_tween.set_trans(Tween.TRANS_ELASTIC)
	shoot_tween.tween_property(carrot_2, "position:z", defult_posz, .4)
