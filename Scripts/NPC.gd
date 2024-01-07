extends KinematicBody2D

signal npc_walk

export var MOVE_STEP = 50
export var ACCELERATION = 50

onready var animation = $animation
onready var move_triger = $move_triger
onready var player = get_node("/root/main/YSort/Player")

var move_status_list = ["IdleDown", "WalkDown", "IdleLeft", "WalkLeft", 
		"IdleUp", "WalkUp", "IdleRight", "WalkRight"]
var move_dir_list = {"WalkUp" : [Vector2(0, -1), "IdleUp"], "WalkLeft" : [Vector2(-1, 0), "IdleLeft"], 
		"WalkDown" : [Vector2(0, 1), "IdleDown"], "WalkRight" : [Vector2(1, 0), "IdleRight"],
		"IdleDown" : [Vector2.ZERO, "IdleDown"], "IdleUp" : [Vector2.ZERO, "IdleUp"],
		"IdleLeft" : [Vector2.ZERO, "IdleLeft"], "IdleRight" : [Vector2.ZERO, "IdleRight"]}
var cur_status = "IdleDown"
var velocity = Vector2.ZERO

func _ready():
	move_triger.start()

func pick_move_status():
	var index = randi() % 8
	return move_status_list[index]

func play_move_animation():
	cur_status = pick_move_status()
	var pick_status_idle = move_dir_list[cur_status][1]
	
	animation.play(pick_status_idle)
	yield(animation, "animation_finished")
	
	emit_signal("npc_walk")
	animation.play(cur_status)
	yield(animation, "animation_finished")
	
	animation.play(pick_status_idle)
	yield(animation, "animation_finished")

func _on_move_triger_timeout():
	move_triger.start()
	play_move_animation()


func _on_NPC_npc_walk():
	var pick_velocity = move_dir_list[cur_status][0]
	
	for _i in range(0, 5, 1):
		velocity = velocity.move_toward(pick_velocity * MOVE_STEP, ACCELERATION)
		velocity = move_and_slide(velocity)
	
	velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
	velocity = move_and_slide(velocity)
	
# 确保玩家y坐标小于npc y坐标时，正确处理覆盖关系
func _on_player_detector_area_entered(_area):
	z_index = player.z_index + 1

# 确保玩家y坐标大于npc y坐标时，正确处理覆盖关系
func _on_player_detector_area_exited(_area):
	z_index = player.z_index
