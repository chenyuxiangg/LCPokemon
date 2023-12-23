extends Camera2D

onready var player = get_node("../Player")

func _ready():
	position = player.position
	offset_h = 0
	offset_v = 0

func _process(_delta):
	position = player.position
