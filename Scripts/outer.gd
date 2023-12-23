extends Node2D

signal player_outer_house1

func _on_area_area_entered(_area):
	emit_signal("player_outer_house1")
