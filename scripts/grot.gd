extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 60.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_l", "move_r")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_animate()
	
	position.x = clamp(position.x, $CollisionShape2D.shape.extents.x, get_viewport_rect().size.x - $CollisionShape2D.shape.extents.x)

func _animate() -> void:
	if Input.is_action_pressed("move_l") or Input.is_action_pressed("move_r"):
		animation_player.play("move")
