extends Node2D

func set_roll_grass_material(resource_name, value):
	get_node("grass_battle/roll_grass").material.set_shader_param(resource_name, value)
	
func set_roll_grass_shadow_material(resource_name, value):
	get_node("grass_battle/roll_grass_shadow").material.set_shader_param(resource_name, value)

func show_carpet():
	get_node("carpet").visible = true
	get_node("carpet/animation").play("carpet_fade_in")
