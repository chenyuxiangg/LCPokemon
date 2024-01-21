extends RichTextLabel

var text_to_type = "hello, world.欢迎来到宝可梦世界。"
var current_index = 0
var typing_speed = 0.1

func set_typing_speed(speed):
	typing_speed = speed
	
func set_typing_text(content):
	text_to_type = content

func start_typing():
	while current_index < text_to_type.length():
		add_text(text_to_type[current_index])
		current_index += 1
		yield(get_tree().create_timer(typing_speed), "timeout")
	get_node("../../../test").position = get_tips_position()
	get_node("../../../test").visible = true
	
func _ready():
	start_typing()
	
func is_chiness(c):
	if c.length() > 1:
		return false
	return (len(c.to_utf8()) == 3)
	
func get_tips_position():
	var y = (get_line_count() - 1 + 0.5) * get_content_height()
	var font = get_font("normal")
	var content = get_text()
	var line_width = rect_size[0]
	var ignore_width = (get_line_count() - 1) * line_width
	var cur_width = 0
	var index = 0
	for i in content.length():
		if is_chiness(content[i]):
			cur_width += font.size
		else:
			cur_width += font.size/2
		if cur_width > ignore_width:
			index = i
			cur_width = 0
			break
	for i in range(index, content.length(), 1):
		if is_chiness(content[i]):
			# 每个中文字符会加2个额外的像素
			cur_width += font.size + 2
		else:
			# 每个英文字符会加2个额外的像素
			cur_width += (font.size + 2)/2
	# x的计算方式如下：
	# 1. 包含最后一行所有字符的宽度（cur_width）
	# 2. tips与最后一个字符间增加半字符宽度的间隔（font.size/2）
	# 3. tips的像素中心位于(0,0),且tips的size=(16,16),因此偏移8像素显示
	var x = cur_width + font.size/2 + 8
	return Vector2(x, y) + rect_global_position
