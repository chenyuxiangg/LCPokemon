extends StaticBody2D

onready var enter_collision = $enter/collision

signal zxz_house1_player_enter

func _on_door_area_entered(_area):
	emit_signal("zxz_house1_player_enter")

func _on_Player_player_walk_up():
	enter_collision.set_deferred("disabled", false)

func _on_Player_player_walk_right():
	enter_collision.set_deferred("disabled", true)


func _on_Player_player_walk_left():
	enter_collision.set_deferred("disabled", true)


func _on_Player_player_walk_down():
	enter_collision.set_deferred("disabled", true)
