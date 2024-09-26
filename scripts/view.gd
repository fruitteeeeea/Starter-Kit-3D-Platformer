extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120

var camera_rotation:Vector3
var zoom = 13

@onready var camera = $Camera

#旋转灵敏度 #kenney设定的初始值是 6
@onready var rotate_sensitive := 18

func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	pass

func _physics_process(delta):
	
	# Set position and rotation to targets
	
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * rotate_sensitive)
	
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right") * -1 #用于反转x轴
	input.x = Input.get_axis("camera_up", "camera_down") * -1 #用于反转y轴
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -45, -10) #仰角和俯角的最大值 #kenney设定的初始值是-80，-10
	
	# Zooming
	
	#zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	#zoom = clamp(zoom, zoom_maximum, zoom_minimum)
