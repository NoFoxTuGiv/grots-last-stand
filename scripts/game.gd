extends Node2D

@onready var pause_menu: Control = $PauseMenu
@onready var game_over_menu: Control = $GameOver
@onready var healthbar: Node2D = $Camera/Healthbar

const BEAKY: PackedScene = preload("res://scenes/beaky.tscn")
const GUTTER: int = 2
const COLS: int = 8
const ROWS: int = 4
const INIT_MOVE_SPEED: float = 10.0
const CLEAR_INCREMENT: float = 10.0
const INIT_SHOT_CD: float = 1.2
var direction: int = 1 # 1 for right, -1 for left
var drop_distance: int = 10
var score: int = 0
var shot_cd: float = INIT_SHOT_CD
var edge_margin: int = 5
var kills: int = 0
@export var clears: int = 0

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
	var live_shots = get_tree().get_nodes_in_group("Beaky_Dakka")

	if beakies.size() == 0:
		clears += 1
		kills = 0
		_generate_grid()

	for beaky in beakies:
		beaky.move(move_speed)

	for beaky in beakies:
		shot_cd -= delta
		#if live_shots.size() < min(min(4 + clears, 10), beakies.size()):
		if live_shots.size() < (min(4 + clears, 10)):
			@warning_ignore("integer_division")
			if (randi() % (2000 / (kills+1))) < 2 and shot_cd < 0:
				shot_cd = INIT_SHOT_CD
				beaky.shoot()
				break

func _generate_grid():
	for i in range(ROWS):
		for j in range(COLS):
			var beaky = BEAKY.instantiate()
			beaky.name = "Beaky" + str(i) + "-" + str(j)
			beaky.position = Vector2(j * (10 + GUTTER), i * (13 + GUTTER))
			beaky.position.x += 5
			beaky.position.y += 5
			beaky.connect("game_over", _game_over)
			beaky.connect("beaky_shoot", _on_beaky_shoot)
			add_child(beaky)
	position = Vector2(edge_margin, 16)

func _on_beaky_killed() -> void:
	kills += 1

func _on_beaky_shoot(shot):
	if healthbar:
		shot.connect("hit_player", healthbar.player_hit)

func _game_over():
	game_over_menu.show()
	get_tree().paused = true
