extends Area2D

@export var speed: float = 40.0

signal hit_player(player: Node)

func _ready() -> void:
	add_to_group("Beaky_Dakka")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	position.y += 1 * speed * delta

	if position.y > get_viewport_rect().size.y:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.name == "Grot":
		print("Hit ", body.name)
		emit_signal("hit_player", body)
		queue_free()
