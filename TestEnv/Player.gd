extends KinematicBody2D

class_name Player

var character_type : CharacterType = PlayerCharacter.new() setget , get_character_type
var player_stats : Stats = PlayerStats.new(5,5) setget set_player_stats, get_player_stats # (health_point, armour_point) 
var player_kine_stats : PlayerKinematicStats = PlayerKinematicStats.new(256, 400) #(detect_radius, speed)


var health : float = player_stats.health
var armour : float = player_stats.armour
var detect_radius : float = player_kine_stats.detect_radius
var speed : int = player_kine_stats.speed
var velocity : Vector2
var bullet : PackedScene = load("res://TestEnv/Bullet.tscn")
var enemies : Array
var target : Area2D = null
var reload : bool = false


var weapon_state = FLAME_PISTOL

enum {
	FLAME_PISTOL,
	FLAMETHROWER
}

func set_player_stats(value) -> void:
	player_stats = value
	health = player_stats.health
	armour = player_stats.armour

func get_player_stats() -> Stats:
	return player_stats


func get_character_type() -> CharacterType:
	return character_type

func _process(delta):
	_move_by_controller(delta)
	target = _find_target()
	_idle_fire()

func _look_at_mouse() -> void:
	look_at(get_global_mouse_position())

func _move_by_controller(delta):
	if velocity == Vector2():
		$Body.play("idle")
	else:
		_face_to_position(velocity)
		$Body.play("move")
	if target != null:
		var target_pos = position.direction_to(target.position)
		_face_to_position(target_pos)
		$Body/Hand.look_at(target.position)
	move_and_collide(velocity * speed * delta)
	position.x = clamp(position.x, 0 , 1080) #temp


func _on_Controller_send_button_pos(pos):
	velocity = pos
	

func _face_to_position(point : Vector2) -> void:
	if point.x >= 0:
		_flip_body(true)
	else:
		_flip_body(false)


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
	match(weapon_state):
		FLAME_PISTOL:
			_fire_pistol()
		FLAMETHROWER:
			flame_fire_up()
	

func _fire_pistol() -> void:
	if velocity == Vector2() and not reload:
		if target != null:
			var new_bullet = bullet.instance()
			new_bullet.transform = $Body/Hand/GunPoint.global_transform
			new_bullet.position = $Body/Hand/GunPoint.global_position
			get_parent().add_child(new_bullet)
			$ReloadTimer.start()
			reload = true


func _flip_body(cond : bool):
	if cond:
		$Body.scale.x = 1
	else:
		$Body.scale.x = -1

func flame_fire_up() -> void:
	if velocity == Vector2():
		$Body/Hand/FireCore.emitting = true
	else:
		$Body/Hand/FireCore.emitting = false


func _on_ReloadTimer_timeout():
	reload = false
