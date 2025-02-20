extends Node2D

const BEAKY: PackedScene = preload("res://scenes/beaky.tscn")
const GUTTER: int = 2
const COLS: int = 8
const ROWS: int = 4
const INIT_MOVE_SPEED: float = 5.0
const CLEAR_INCREMENT: float = 5.0
var move_speed: float = 5.0
var clears: int = 0
var direction: int = 1 # 1 for right, -1 for left
var drop_distance: int = 10
@export var edge_margin = 5

var reverse_cooldown: float = 0.5
var last_reverse_time: float = 0.0

signal game_over

func _ready() -> void:
	_generate_grid()
	

func _physics_process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var beakies = get_tree().get_nodes_in_group("Beakies")

	var live_shot_count = get_tree().get_nodes_in_group("live_shots").size()
	print("Live shots: ", live_shot_count)

	# TODO: Shoot the player
	for beaky in beakies:
		pass

	# Increment the reverse cooldown timer
	last_reverse_time += delta

	# Move the grid horizontally
	position.x += move_speed * direction * delta

	# Game Over condition
	if position.y + get_height() > viewport_size.y:
		_on_reached_bottom()

	# Check if all Beakies are destroyed
	if len(beakies) == 0:
		clears = clears + 1
		print(clears)
		move_speed = INIT_MOVE_SPEED + (clears * CLEAR_INCREMENT)
		_generate_grid()

func _generate_grid():
	for i in range(ROWS):
		for j in range(COLS):
			var beaky = BEAKY.instantiate()
			beaky.name = "Beaky" + str(i) + "-" + str(j)
			beaky.position = Vector2(j * (10 + GUTTER), i * (13 + GUTTER))
			beaky.connect("hit_wall", Callable(self, "_on_hit_wall"))
			beaky.connect("reached_bottom", Callable(self, "_on_reached_bottom"))
			beaky.connect("hit_enemy", Callable(self, "_on_enemy_removed"))
			add_child(beaky)
	position = Vector2(edge_margin, 16)

func _on_hit_wall() -> void:
	if last_reverse_time >= reverse_cooldown:
		#print("Wall hit detected. Reversing direction.")
		direction *= -1
		position.y += drop_distance
		last_reverse_time = 0.0

func _on_enemy_removed(_enemy: Node) -> void:
	move_speed += 1.25
	print("Beaky removed. New move_speed:", move_speed)

func _on_reached_bottom() -> void:
	game_over.emit()

func get_height() -> float:
	var max_y = -INF
	for beaky in get_tree().get_nodes_in_group("Beakies"):
		max_y = max(max_y, beaky.global_position.y)
	return max_y - position.y + drop_distance
