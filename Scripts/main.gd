extends Node2D

onready var townnote = $townnote
onready var camera = $camera
onready var world = $world
onready var ysort = $YSort
onready var player = $YSort/Player
onready var interlude = $interlude
onready var battle = $battle
onready var current_screen_center = camera.get_camera_screen_center()

const WIN_PLATFORM_WINDOW_LEFT_OFFSET: Vector2 = Vector2(-160, -90)
const WIN_PLATFORM_NOTE_OFFSET: Vector2 = Vector2(31, -5)

export(Vector2) var window_left_offset = WIN_PLATFORM_WINDOW_LEFT_OFFSET
export(Vector2) var note_offset = WIN_PLATFORM_NOTE_OFFSET

func _ready():
	townnote.visible = false
	townnote.position = normalize_townnote_pos()

func normalize_townnote_pos():
	return camera.get_camera_screen_center() + window_left_offset + note_offset

func _on_camera_screen_center_changed():
	townnote.position = normalize_townnote_pos()
	
func enable_input():
	player.enable_move()
	
func disable_input():
	player.disable_move()

func _on__player_change_sence_to_outdoor():
	disable_input()
	interlude.fade_out()
	yield(interlude, "finished")
	townnote.show()
	get_node("YSort/真新镇").outer_house()
	interlude.fade_out(true)
	yield(interlude, "finished")
	enable_input()

func _on_battle_entered(_area):
	interlude.fence_in()
	yield(interlude, "finished")
	ysort.visible = false
	world.visible = false
	interlude.keep_black_screen(true)
	get_node("timer/battle_delay").start()

func _on_battle_delay_timeout():
	interlude.keep_black_screen(false)
	interlude.open_eye()
	battle.visible = true
	get_node("timer/carpet_in_delay").start()
	battle.set_roll_grass_material("enable", true)
	battle.set_roll_grass_shadow_material("enable", true)
	battle.get_node("grass_battle/animation").play("grass_fade_out")
	yield(battle.get_node("grass_battle/animation"), "animation_finished")
	battle.set_roll_grass_material("enable", false)
	battle.set_roll_grass_shadow_material("enable", false)

func _on_carpet_in_delay_timeout():
	battle.show_characters()

func _on__player_change_sence_to_house():
	disable_input()
	interlude.fade_out()
	yield(interlude, "finished")
	get_node("YSort/真新镇").enter_house()
	interlude.fade_out(true)
	yield(interlude, "finished")
	enable_input()
