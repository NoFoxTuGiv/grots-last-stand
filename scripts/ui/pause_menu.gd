extends Control

@onready var resumeBtn: Button = $CenterContainer/VBoxContainer/Resume
@onready var game_over: Control = $"../GameOver"

func resume():
	self.hide()
	get_tree().paused = false

func pause():
	self.show()
	get_tree().paused = true

func restart():
	self.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func testEsc():
	if game_over.is_visible_in_tree():
		pass
	elif Input.is_action_just_pressed("pause") and !get_tree().paused:
		resumeBtn.grab_focus()
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	restart()

func _process(_delta: float) -> void:
	testEsc()
