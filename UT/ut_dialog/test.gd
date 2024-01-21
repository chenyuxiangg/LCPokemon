extends Node2D

onready var dialog = $dialog

var test_content

func _ready():
	test_content = "我我我我我我我我我我我我我我我我我我我我我我我我我我我"
	test_content += "我我我我我我我我我我我我我我我我我我我我我我我我我我我"
	test_content += "我我我我我我我我我我我我我我我我我我我我我我我我我我我"
	test_content += "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
	test_content += "i"

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			dialog.visible = true
			dialog.start_typing(test_content, 0)

func _on_dialog_typing_finished():
	dialog.visible = false
	dialog.clear()
