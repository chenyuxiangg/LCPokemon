extends Node2D

export(float) var typing_speed = 0.1

onready var animation = $animation
onready var label = $label
onready var tips = $tips
onready var origin_position = position

var cur_screen_text = ""
var is_start_typing = false

signal typing_finished
signal typing_continue

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			if is_start_typing:
				get_tree().set_input_as_handled()
			if tips.visible:
				cur_screen_text = ""
				emit_signal("typing_continue")
				
func clear():
	show_tips(false, true)
	label.clear()

func start_typing(content, start_index):
	is_start_typing = true
	var cur_index = start_index
	while cur_index < content.length():
		label.add_text(content[cur_index])
		cur_screen_text += content[cur_index]
		cur_index += 1
		yield(get_tree().create_timer(typing_speed), "timeout")
		if label.get_text().length() == content.length():
			show_tips(true, false)
			yield(self, "typing_continue")
			show_tips(false, false)
			break
		if is_full_label():
			show_tips(true, true)
			yield(self, "typing_continue")
			show_tips(false, true)
	emit_signal("typing_finished")
	is_start_typing = false
	
func show_tips(enable, is_full):
	if enable:
		if is_full:
			tips.position = get_tips_position() - origin_position
		else:
			var font = label.get_font("normal")
			var char_height = font.size + 0.25
			var pos = get_tips_position() - origin_position
			var extra_line_counts = get_max_lines() - get_cur_screen_line_counts()
			pos.y += extra_line_counts * char_height
			pos.x -= font.size
			tips.position = pos
		tips.visible = true
	else:
		tips.visible = false
	
func is_full_label():
	var text_size = get_tips_position() - label.rect_global_position
	var font = label.get_font("normal")
	text_size.x -= 4
	var max_pixel = (get_max_chiness_chars_per_line(font.size)-1) * font.size
	if get_cur_screen_line_counts() == get_max_lines():
		if text_size.x >= max_pixel:
			return true
		elif text_size.x + font.size/2 >= max_pixel:
			return true
	return false
	
func is_chiness(c):
	if c.length() > 1:
		return false
	return (len(c.to_utf8()) == 3)
	
func get_tips_position():
	var line_couts = get_cur_screen_line_counts()
	var font = label.get_font("normal")
	var char_height = font.size + 0.25
	var line_width = label.rect_size[0]
	var ignore_width = (line_couts - 1) * line_width
	var cur_width = 0
	var index = 0
	for i in cur_screen_text.length():
		if is_chiness(cur_screen_text[i]):
			cur_width += font.size
		else:
			cur_width += font.size/2
		if cur_width > ignore_width:
			index = i
			cur_width = 0
			break
	for i in range(index, cur_screen_text.length(), 1):
		if is_chiness(cur_screen_text[i]):
			cur_width += font.size
		else:
			cur_width += font.size/2
	# x的计算方式如下：
	# 1. 包含最后一行所有字符的宽度（cur_width）
	var x = cur_width
	var y = (line_couts - 1 + 0.8) * char_height
	var pos = Vector2(x, y) + label.rect_global_position
	# 保证在超过半行后tips不覆盖字符
	pos.x += 4
	return pos
	
func get_max_chiness_chars_per_line(font_size):
	return int(label.rect_size[0]/font_size)

func get_cur_screen_line_counts():
	var font = label.get_font("normal")
	var cur_width = 0
	var line_count = 0
	for i in cur_screen_text.length():
		if is_chiness(cur_screen_text[i]):
			cur_width += font.size
		else:
			cur_width += font.size/2
		if cur_width >= label.rect_size[0]:
			cur_width = 0
			line_count += 1
	if cur_width != 0:
		line_count += 1
	return line_count

func get_max_lines():
	var font = label.get_font("normal")
	return int(label.rect_size[1]/(font.size + 0.25))
