extends EnemyProjectile

var direction : Vector2 setget set_direction
var SPEED : float = 300
var damage : float = 3


func set_direction(value : Vector2) -> void:
	direction = value

func _process(delta):
	position += direction * SPEED * delta


func _on_BossBullet_area_entered(area):
	var body = area.get_parent()
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(damage)
				body.knockback(self, 0.5, 300)
				queue_free()


func _on_BossBullet_body_exited(body):
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(damage)
				body.knockback(self, 0.5, 300)
				queue_free()
	elif body is TileMap:
		queue_free()
