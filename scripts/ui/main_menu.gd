extends Control

@onready var start: Button = $MainMenu/MarginContainer/VBoxContainer/Start
@onready var settings: Button = $MainMenu/MarginContainer/VBoxContainer/Settings
@onready var quit: Button = $MainMenu/MarginContainer/VBoxContainer/Quit
@onready var main_menu: PanelContainer = $MainMenu
@onready var main_settings: PanelContainer = $MainSettings
@onready var resolution_settings: PanelContainer = $ResolutionSettings
@onready var resolution: Button = $MainSettings/MarginContainer/VBoxContainer/Resolution
@onready var res_back: Button = $ResolutionSettings/MarginContainer/VBoxContainer/ResBack

const GAME = "res://scenes/game.tscn"

func _ready() -> void:
	DisplayServer.window_set_size(Vector2(800, 720))
	get_window().move_to_center()
	start.grab_focus()
	main_settings.hide()
	resolution_settings.hide()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(GAME)

func _on_settings_pressed() -> void:
	main_settings.show()
	resolution.grab_focus()
	main_menu.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	main_settings.hide()
	main_menu.show()
	start.grab_focus()

func _on_res_back_pressed() -> void:
	resolution_settings.hide()
	main_settings.show()
	resolution.grab_focus()

func _on_resolution_pressed() -> void:
	main_settings.hide()
	resolution_settings.show()
	res_back.grab_focus()

func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(3)
	else:
		DisplayServer.window_set_mode(0)

func _on__x_1440_pressed() -> void:
	DisplayServer.window_set_size(Vector2(1600, 1440))
	get_window().move_to_center()

func _on__x_1008_pressed() -> void:
	DisplayServer.window_set_size(Vector2(1120, 1008))
	get_window().move_to_center()

func _on__x_720_pressed() -> void:
	DisplayServer.window_set_size(Vector2(800, 720))
	get_window().move_to_center()

func _on__x_432_pressed() -> void:
	DisplayServer.window_set_size(Vector2(480, 432))
	get_window().move_to_center()

func _on__x_144_pressed() -> void:
	DisplayServer.window_set_size(Vector2(160, 144))
	get_window().move_to_center()

func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	print(str(AudioServer.get_bus_volume_db(0)))
