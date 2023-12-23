extends YSort

onready var tiles = $tiles
onready var background = $background
onready var house_1_in = $house_1/in
onready var house_1_out = $house_1/out
onready var scence_change = $scence_change/animation
onready var player = get_node("../Player")

func _on_house_1_zxz_house1_player_enter():
	scence_change.play("scence_change")
	yield(scence_change,"animation_finished")
	
	background.visible = false
	tiles.visible = false
	house_1_out.visible = false
	house_1_in.visible = true
	
	house_1_in.get_node("tiles").set_collision_mask_bit(2, false)
	house_1_in.get_node("tiles").set_collision_mask_bit(0, true)
	house_1_in.get_node("space/room_range").set_collision_mask_bit(2, false)
	house_1_in.get_node("space/room_range").set_collision_mask_bit(0, true)
	house_1_in.get_node("outer/area").set_collision_mask_bit(2, false)
	house_1_in.get_node("outer/area").set_collision_mask_bit(0, true)
	
	house_1_out.get_node("house_1").set_collision_mask_bit(0, false)
	house_1_out.get_node("house_1").set_collision_mask_bit(3, true)
	
	tiles.set_collision_mask_bit(0, false)
	tiles.set_collision_mask_bit(2, true)
	
	player.position = Vector2(160, 125)
	scence_change.play_backwards("scence_change")
	yield(scence_change, "animation_finished")


func _on_outer_player_outer_house1():
	scence_change.play("scence_change")
	yield(scence_change,"animation_finished")
	
	house_1_in.visible = false
	background.visible = true
	house_1_out.visible = true
	tiles.visible = true
	
	house_1_in.get_node("tiles").set_collision_mask_bit(2, true)
	house_1_in.get_node("tiles").set_collision_mask_bit(0, false)
	house_1_in.get_node("space/room_range").set_collision_mask_bit(2, true)
	house_1_in.get_node("space/room_range").set_collision_mask_bit(0, false)
	house_1_in.get_node("outer/area").set_collision_mask_bit(2, true)
	house_1_in.get_node("outer/area").set_collision_mask_bit(0, false)
	
	house_1_out.get_node("house_1").set_collision_mask_bit(0, true)
	house_1_out.get_node("house_1").set_collision_mask_bit(3, false)
	
	tiles.set_collision_mask_bit(0, true)
	tiles.set_collision_mask_bit(2, false)
	
	player.position = Vector2(24, 33) + house_1_out.get_node("house_1").position
	scence_change.play_backwards("scence_change")
	yield(scence_change, "animation_finished")
