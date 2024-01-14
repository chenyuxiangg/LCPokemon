extends Node2D

signal finished

func fade_out(backward=false):
	visible = true
	get_node("full_cover").visible = true
	
	if not backward:
		get_node("animation").play("fade_out")
	else:
		get_node("animation").play_backwards("fade_out")
	
	yield(get_node("animation"), "animation_finished")
	get_node("full_cover").visible = false
	visible = false
	emit_signal("finished")


func fence_in(backward=false):
	visible = true
	get_node("left_cover").visible = true
	get_node("right_cover").visible = true
	
	if not backward:
		get_node("animation").play("fence_in")
	else:
		get_node("animation").play_backwards("fence_in")

	yield(get_node("animation"), "animation_finished")
	get_node("left_cover").visible = false
	get_node("right_cover").visible = false
	visible = false
	emit_signal("finished")

func open_eye(backward=false):
	visible = true
	get_node("up_cover").visible = true
	get_node("down_cover").visible = true
	
	if not backward:
		get_node("animation").play("open_eye")
	else:
		get_node("animation").play_backwards("open_eye")

	yield(get_node("animation"), "animation_finished")
	get_node("up_cover").visible = false
	get_node("down_cover").visible = false
	visible = false
	emit_signal("finished")

func keep_black_screen(enable=false):
	visible = enable
	get_node("black_screen").visible = enable
