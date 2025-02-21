extends Node

@onready var health_0: Sprite2D = $Health0
@onready var health_1: Sprite2D = $Health1
@onready var health_2: Sprite2D = $Health2

func player_hit() -> void:
	print("Player Hit signal received by healthbar")
