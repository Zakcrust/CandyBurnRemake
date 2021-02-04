extends EnemyProjectile


var speed : float = 300 setget set_speed, get_speed
var damage : float = 1.0
var knockback_speed : float = 200
var knockback_duration : float = 0.3

func set_speed(value) -> void:
	speed = value

func get_speed() -> float:
	return speed


func _process(delta):
	position += transform.x * speed * delta

func _on_Bolt_body_entered(body):
	if body is TileMap:
		queue_free()
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(damage)
				body.knockback(self, knockback_duration, knockback_speed)
				queue_free()


func _on_Bolt_area_entered(area):
	var body = area.get_parent()
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(damage)
				body.knockback(self, knockback_duration, knockback_speed)
				queue_free()
