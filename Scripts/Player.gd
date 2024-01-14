extends KinematicBody2D

export var MAX_SPEED = 50
export var ACCELERATION = 200
export(String) var location = "真新镇"

var velocity = Vector2.ZERO
var en_move = true

onready var animation_tree = $animation_tree_player
onready var animation_status = animation_tree.get("parameters/playback")

signal player_walk_up
signal player_walk_down
signal player_walk_left
signal player_walk_right

func announce_move_direction():
	var dir_down = Input.is_action_pressed("ui_down")
	var dir_up = Input.is_action_pressed("ui_up")
	var dir_left = Input.is_action_pressed("ui_left")
	var dir_right = Input.is_action_pressed("ui_right")
	
	if dir_down and not dir_up:
		emit_signal("player_walk_down")
	elif dir_up and not dir_down:
		emit_signal("player_walk_up")
	elif dir_left and not dir_right:
		emit_signal("player_walk_left")
	elif dir_right and not dir_left:
		emit_signal("player_walk_right")
	else:
		pass
		
func enable_move():
	en_move = true
	
func disable_move():
	en_move = false

func move(delta):
	if !en_move:
		return
		
	var input_velocity = Vector2.ZERO
	input_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_velocity = input_velocity.normalized()

	if input_velocity != Vector2.ZERO:
		announce_move_direction()
		animation_tree.set("parameters/Idle/blend_position", input_velocity)
		animation_tree.set("parameters/Walk/blend_position", input_velocity)
		animation_status.travel("Walk")
		velocity = velocity.move_toward(input_velocity * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_status.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func _physics_process(delta):
	move(delta)
