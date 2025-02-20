extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var dakka: PackedScene = preload("res://scenes/grot_dakka.tscn")
var is_shooting: bool = false

const SPEED = 60.0

signal beaky_killed

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("move_l", "move_r")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_animate()
	_shoot()
	
	position.x = clamp(position.x, $CollisionShape2D.shape.extents.x, get_viewport_rect().size.x - $CollisionShape2D.shape.extents.x)

func _animate() -> void:
	if Input.is_action_pressed("move_l") or Input.is_action_pressed("move_r"):
		animation_player.play("move")

func _shoot() -> void:
	if Input.is_action_just_pressed("shoot") and not is_shooting:
		var shot = dakka.instantiate()
		shot.global_position = self.global_position    
		shot.global_position.x -= 5
		shot.global_position.y -= 15
		get_parent().add_child(shot)
		is_shooting = true
		shot.connect("hit_enemy", _on_enemy_removed)
		shot.connect("tree_exited", _on_bullet_removed)

func _on_bullet_removed() -> void:
	is_shooting = false

func _on_enemy_removed(beaky) -> void:
	print(beaky.name, " was killed.")
	emit_signal("beaky_killed")
