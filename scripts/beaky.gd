extends Area2D

const SM_DAKKA: PackedScene = preload("res://scenes/sm_dakka.tscn")
const MAX_SHOOTERS: int = 5
const REV_CD: float = 0.5
var direction = 1 # 1 for right, -1 for left
var last_reverse_time: float = 0.0

signal game_over

func _ready() -> void:
	add_to_group("Beakies")

func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var live_shots = get_tree().get_nodes_in_group("Beaky_Dakka")

	last_reverse_time += delta

	# Check for hitting the wall
	if position.x <= 4 or position.x + 4 >= viewport_size.x:
		if last_reverse_time >= REV_CD:
			position.y += 6
			direction *= -1
			last_reverse_time = 0

	if live_shots.size() < 3:
		if (randi() % 20) < 2:
			_shoot()

	# Check if it reaches the bottom
	if position.y >= viewport_size.y:
		print(self.name, " reached bottom. Game Over!")
		emit_signal("game_over")

	# Check for collision with player
	for body in get_overlapping_bodies():
		if body.name == "Grot":
			print(self.name, " collided with player! Game Over.")
			emit_signal("game_over")

func _shoot() -> void:
		var shot = SM_DAKKA.instantiate()
		shot.name = self.name + "_shot"
		shot.position = self.position
		shot.position.y += 5
		shot.add_to_group("Beaky_Dakka")
		get_parent().add_child(shot)

func move(speed) -> void:
	position.x += speed * direction
