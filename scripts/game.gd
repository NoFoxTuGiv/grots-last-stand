extends Node2D

@onready var pause_menu: Control = $PauseMenu
@onready var game_over: Control = $GameOver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()
	game_over.hide()
