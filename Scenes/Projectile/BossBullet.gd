extends EnemyProjectile

var direction : Vector2 setget set_direction
var SPEED : float = 300

func set_direction(value : Vector2) -> void:
	direction = value

func _process(delta):
	position += direction * SPEED * delta
