extends Node2D

@onready var pause_menu: Control = $PauseMenu
@onready var game_over_menu: Control = $GameOver

const BEAKY: PackedScene = preload("res://scenes/beaky.tscn")
const GUTTER: int = 2
const COLS: int = 8
const ROWS: int = 4
const INIT_MOVE_SPEED: float = 5.0
const CLEAR_INCREMENT: float = 5.0
var kills: int = 0
@export var clears: int = 0
var direction: int = 1 # 1 for right, -1 for left
var drop_distance: int = 10
var score = 0
@export var edge_margin = 5

var reverse_cooldown: float = 0.5
var last_reverse_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()
	game_over_menu.hide()
	_generate_grid()

func _physics_process(delta: float) -> void:
	var move_speed = ((INIT_MOVE_SPEED + (clears * CLEAR_INCREMENT) + kills) * delta)
	var beakies = get_tree().get_nodes_in_group("Beakies")

	if beakies.size() == 0:
		clears += 1
		kills = 0
		_generate_grid()
	for beaky in beakies:
		beaky.move(move_speed)

func _generate_grid():
	for i in range(ROWS):
		for j in range(COLS):
			var beaky = BEAKY.instantiate()
			beaky.name = "Beaky" + str(i) + "-" + str(j)
			beaky.position = Vector2(j * (10 + GUTTER), i * (13 + GUTTER))
			beaky.position.x += 5
			beaky.position.y += 5
			beaky.connect("game_over", _game_over)
			add_child(beaky)
	position = Vector2(edge_margin, 16)

func _on_beaky_killed() -> void:
	kills += 1
	score += 1

func _game_over():
	game_over_menu.show()
	get_tree().paused = true
