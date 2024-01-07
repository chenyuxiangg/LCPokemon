extends Camera2D

onready var player = get_node("/root/main/YSort/Player")
onready var current_screen_center = get_camera_screen_center()

signal screen_center_changed

func _ready():
	position = player.position
	offset_h = 0
	offset_v = 0

func _process(_delta):
	position = player.position
	if current_screen_center != get_camera_screen_center():
		current_screen_center = get_camera_screen_center()
		emit_signal("screen_center_changed")
