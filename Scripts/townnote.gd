extends Node2D

func show():
	visible = true
	get_node("animation").play("fade_in")
	yield(get_node("animation"), "animation_finished")
	
	# 动画保持1s
	get_node("timer").start()
	yield(get_node("timer"), "timeout")
	
	get_node("animation").play_backwards("fade_in")
	yield(get_node("animation"), "animation_finished")
	visible = false
