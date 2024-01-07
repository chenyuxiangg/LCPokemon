extends YSort

onready var tiles = $tiles
onready var background = get_node("/root/main/world")
onready var house_1_out = get_node("house/house_1/out")
onready var scence_change = get_node("scence_change/animation")
onready var player = get_node("/root/main/YSort/Player")
onready var npcs = get_node("npc")

var house_num = 0
var current_house_id = 0
var current_town_name = "真新镇"

signal updated_current_house
signal player_change_sence_to_outdoor

func set_house_out_visible(house_id, enable):
	var out = get_node("house/house_{id}/out".format({"id" : house_id}))
	out.visible = enable
	out.get_node("body_collision").set_collision_mask_bit(0, enable)
	out.get_node("body_collision").set_collision_mask_bit(3, !enable)
	
func set_house_in_visible(house_id, enable):
	var inner = get_node("house/house_{id}/in".format({"id" : house_id}))
	inner.visible = enable
	inner.get_node("tiles").set_collision_mask_bit(2, !enable)
	inner.get_node("tiles").set_collision_mask_bit(0, enable)
	inner.get_node("space/room_range").set_collision_mask_bit(2, !enable)
	inner.get_node("space/room_range").set_collision_mask_bit(0, enable)
	inner.get_node("outer/area").set_collision_mask_bit(2, !enable)
	inner.get_node("outer/area").set_collision_mask_bit(0, enable)
	
func set_background_visible(enable):
	background.visible = enable
	tiles.visible = enable
	tiles.set_collision_mask_bit(0, enable)
	tiles.set_collision_mask_bit(2, !enable)

func _on_door_area_entered(_area):
	yield(self, "updated_current_house")
	scence_change.play("scence_change")
	yield(scence_change,"animation_finished")
	
	set_background_visible(false)
	
	for i in range(1, house_num+1):
		set_house_out_visible(i, false)
		
	for npc in npcs.get_children():
		npc.visible = false
		
	set_house_in_visible(current_house_id, true)
	
	player.position = Vector2(160, 125)
	scence_change.play_backwards("scence_change")
	yield(scence_change, "animation_finished")

func _on_area_area_entered(_area):
	if current_house_id == 0:
		return
	scence_change.play("scence_change")
	yield(scence_change,"animation_finished")
	
	set_background_visible(true)
	
	for i in range(1, house_num+1):
		set_house_out_visible(i, true)
		
	for npc in npcs.get_children():
		npc.visible = true
		
	set_house_in_visible(current_house_id, false)
	
	player.position = Vector2(-8, 20) + \
		get_node("/root/main/YSort/{town_name}/house/house_{house_id}/out"\
		.format({"town_name" : current_town_name, "house_id" : current_house_id})).position
	scence_change.play_backwards("scence_change")
	yield(scence_change, "animation_finished")
	emit_signal("player_change_sence_to_outdoor")

func _on_house_new_house():
	house_num += 1

func _on_house_player_enter_house(house_id):
	current_house_id = house_id
	emit_signal("updated_current_house")
