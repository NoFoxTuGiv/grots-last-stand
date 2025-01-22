extends Area2D

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2(0, 1)

signal hit_player(player: Node)

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

	if position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.name == "Grot":
		emit_signal("hit_player", body)
		queue_free()
