extends Node2D

onready var house_in = $in
onready var house_out = $out
onready var door_collision = house_out.get_node("door/door_collision")

export var house_id = 0

signal player_enter_house(house_id)
signal new_house
	
func _ready():
	emit_signal("new_house")

func _on_door_area_entered(_area):
	emit_signal("player_enter_house", house_id)

func _on_Player_player_walk_up():
	door_collision.set_deferred("disabled", false)

func _on_Player_player_walk_right():
	door_collision.set_deferred("disabled", true)


func _on_Player_player_walk_left():
	door_collision.set_deferred("disabled", true)


func _on_Player_player_walk_down():
	door_collision.set_deferred("disabled", true)
