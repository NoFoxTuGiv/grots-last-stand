extends Area2D

const SPEED: float = 200.0
const DIRECTION: Vector2 = Vector2(0, -1)

signal hit_enemy(enemy: Node)

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta: float) -> void:
	position += DIRECTION * SPEED * delta

	if position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()

func _on_area_entered(area: Node) -> void:
	#print("Collision detected with:", area)
	if area.is_in_group("Beakies"):
		emit_signal("hit_enemy", area)
		area.queue_free()
		queue_free()
