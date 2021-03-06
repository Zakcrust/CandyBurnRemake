extends Projectile

var bullet_speed : int = 400 setget set_speed, get_speed
var bullet_damage : int = 0
var trail_length : int = 20

var explosion_scene = load("res://Scenes/Explosion/Explosion.tscn")

func _process(delta):
	position += transform.x * bullet_speed * delta

func set_speed(value) -> void:
	bullet_speed = value

func get_speed() -> int:
	return bullet_speed


func _on_Bullet_area_entered(area):
	var enemy = area.get_parent()
	if area is Dummy:
		queue_free()
	elif enemy is Character:
		match enemy.character_type:
			CharacterTypes.ENEMY:
				if enemy.current_status == CharacterStatus.ALIVE:
					enemy.hit(bullet_damage)
					queue_free()
			CharacterTypes.BOSS:
				if enemy.current_status == CharacterStatus.ALIVE:
					enemy.hit(bullet_damage)
					queue_free()


func _on_Bullet_body_entered(body):
	if body is Dummy:
		queue_free()
	elif body is Character:
		match body.character_type:
			CharacterTypes.ENEMY:
				if body.current_status == CharacterStatus.ALIVE:
					body.hit(bullet_damage)
					queue_free()
			CharacterTypes.BOSS:
				if body.current_status == CharacterStatus.ALIVE:
					body.hit(bullet_damage)
					queue_free()
	if body is TileMap:
		queue_free()


func _on_Timer_timeout():
	queue_free()


func _on_Bullet_tree_exiting():
	var new_explosion = explosion_scene.instance()
	new_explosion.position = global_position
	get_parent().call_deferred("add_child",new_explosion)
