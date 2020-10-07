extends KinematicBody2D


var speed : int = 200

var velocity : Vector2
var bullet : PackedScene = load("res://TestEnv/Bullet.tscn")

var enemies : Array
var target : Area2D = null

var reload : bool = false

func _process(delta):
	_move_by_controller(delta)
	target = _find_target()
	_idle_fire()

func _look_at_mouse() -> void:
	look_at(get_global_mouse_position())

func _move_by_controller(delta):
	look_at(position + (velocity * speed))
	if velocity == Vector2():
		$Sprite.play("idle")
	else:
		$Sprite.play("move")
	move_and_collide(velocity * speed * delta)


func _on_Controller_send_button_pos(pos):
	velocity = pos
	


func _on_Controller_send_shoot():
	var new_bullet = bullet.instance()
	new_bullet.transform = $GunPoint.global_transform
	new_bullet.global_position = $GunPoint.global_position
	get_parent().add_child(new_bullet)


func _on_EnemyDetector_send_enemies(ens):
	enemies = ens


func _find_target() -> Area2D:
	var distance_array : Array
	for enemy in enemies:
		distance_array.append(abs(position.distance_to(enemy.position)))
	distance_array.sort()
	for enemy in enemies:
		if position.distance_to(enemy.position) == distance_array.front():
			return enemy
	return null

func _idle_fire():
	if velocity == Vector2() and not reload:
		if target != null:
			look_at(target.position)
			var new_bullet = bullet.instance()
			new_bullet.transform = $GunPoint.global_transform
			new_bullet.position = $GunPoint.global_position
			get_parent().add_child(new_bullet)
			$ReloadTimer.start()
			reload = true


func _on_ReloadTimer_timeout():
	reload = false
