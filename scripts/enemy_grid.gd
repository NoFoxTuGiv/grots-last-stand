extends Node2D

const BEAKY: PackedScene = preload("res://scenes/beaky.tscn")
const GUTTER: int = 2
const COLS: int = 8
const ROWS: int = 4
var move_speed: float = 5.0
var direction: int = 1 # 1 for right, -1 for left
var drop_distance: int = 10
@export var edge_margin = 5

var reverse_cooldown: float = 0.5
var last_reverse_time: float = 0.0

func _ready() -> void:
    _generate_grid()
    var connected = get_tree().connect("hit_enemy", Callable(self, "_on_enemy_removed"))
    if connected == OK:
        print("Signal 'hit_enemy' successfully connected in enemy_grid")
    else:
        print("Failed to connect 'hit_enemy' signal")

func _physics_process(delta: float) -> void:
    var viewport_size = get_viewport_rect().size
    var beakies = get_tree().get_nodes_in_group("Beakies")

    # Increment the reverse cooldown timer
    last_reverse_time += delta

    # Move the grid horizontally
    position.x += move_speed * direction * delta

    # Game Over condition
    if position.y + get_height() > viewport_size.y:
        print("Game Over")
        get_tree().paused = true

    # Check if all Beakies are destroyed
    if len(beakies) == 0:
        get_tree().paused = true
        print("All Beakies Destroyed")

func _generate_grid():
    for i in range(ROWS):
        for j in range(COLS):
            var beaky = BEAKY.instantiate()
            beaky.position = Vector2(j * (10 + GUTTER), i * (13 + GUTTER))
            beaky.connect("hit_wall", Callable(self, "_on_hit_wall"))
            beaky.connect("reached_bottom", Callable(self, "_on_reached_bottom"))
            add_child(beaky)
    position = Vector2(edge_margin, 16)

func _on_hit_wall() -> void:
    if last_reverse_time >= reverse_cooldown:
        print("Wall hit detected. Reversing direction.")
        direction *= -1
        position.y += drop_distance
        last_reverse_time = 0.0

func _on_enemy_removed(_enemy: Node) -> void:
    move_speed += 1.25
    print("Beaky removed. New move_speed:", move_speed)

func _on_reached_bottom() -> void:
    print("Beaky reached bottom. Game Over.")
    get_tree().paused = true

func get_height() -> float:
    var max_y = -INF
    for beaky in get_tree().get_nodes_in_group("Beakies"):
        max_y = max(max_y, beaky.global_position.y)
    return max_y - position.y + drop_distance
