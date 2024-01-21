extends Node2D

signal fade_in_finished

func fade_in():
	get_node("mc").visible = true
	get_node("ec").visible = true
	get_node("animation").play("fade_in")
	yield(get_node("animation"), "animation_finished")
	emit_signal("fade_in_finished")
