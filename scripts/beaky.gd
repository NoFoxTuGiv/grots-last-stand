extends Area2D

signal hit_wall
signal reached_bottom
signal game_over

@export var move_speed: float = 5.0

func _ready() -> void:
    add_to_group("Beakies")

func _process(delta: float) -> void:
    var viewport_size = get_viewport_rect().size
    var global_pos = global_position

    # Check for hitting the wall
    if global_pos.x <= 4 or global_pos.x + 4 >= viewport_size.x:
        emit_signal("hit_wall")
    
    # Check if it reaches the bottom
    if global_pos.y >= viewport_size.y:
        emit_signal("reached_bottom")
        emit_signal("game_over")

    # Check for collision with player
    for body in get_overlapping_bodies():
        if body.name == "Player":
            print("Beaky collided with player! Game Over.")
            emit_signal("game_over")