extends EnemyProjectile


var speed : float = 300 setget set_speed, get_speed

func set_speed(value) -> void:
	speed = value

func get_speed() -> float:
	return speed


func _process(delta):
	position += transform.x * speed * delta

func _on_Bolt_body_entered(body):
	if body is Player or TileMap:
		queue_free()
