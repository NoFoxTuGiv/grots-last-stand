extends Node

@onready var health_0: Sprite2D = $Health0
@onready var health_1: Sprite2D = $Health1
@onready var health_2: Sprite2D = $Health2
var health = 3
signal game_over

func player_hit(_body) -> void:
	%Explosion.play()
	health -= 1
	match health:
		2: health_2.hide()
		1: health_1.hide()
		0: health_0.hide()
		-1: game_over.emit()
