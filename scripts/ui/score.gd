extends Node

var score: int = 0

func _on_beaky_killed() -> void:
	score += 10
	self.text = str(score) + " PTS"
