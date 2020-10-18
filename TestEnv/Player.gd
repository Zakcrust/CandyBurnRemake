extends KinematicBody2D

class_name Player

var character_type : CharacterType = PlayerCharacter.new() setget , get_character_type
var player_stats : Stats = PlayerStats.new(5,5) setget set_player_stats, get_player_stats # (health_point, armour_point) 
var player_kine_stats : PlayerKinematicStats = PlayerKinematicStats.new(256, 400) #(detect_radius, speed)

##### DEBUG #####
export (int) var custom_speed = 400
export (int) var bullet_speed = 300
#################


var health : float = player_stats.health
var armour : float = player_stats.armour
var detect_radius : float = player_kine_stats.detect_radius
var speed : int = player_kine_stats.speed
var knockback_speed : float = speed * 3
var velocity : Vector2
var knockback_direction : Vector2
var bullet : PackedScene = load("res://TestEnv/Bullet.tscn")
var enemies : Array
var target : Area2D = null
var reload : bool = false
var collosion 

var can_shoot : bool  = true

var weapon_state = FLAME_PISTOL
var state = MOVE
enum {
	FLAME_PISTOL,
	FLAMETHROWER,
	MOVE,
	HURT,
	DEAD
}

enum enemy_state {
	IDLE,
	MOVE,
	DEAD
}

func _ready():
	speed = custom_speed
	knockback_speed = speed * 3


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
	match(state):
		MOVE:
			if velocity == Vector2():
				$Body.play("idle")
			else:
				_face_to_position(velocity)
				$Body.play("move")
			if target != null:
				var target_pos = position.direction_to(target.position)
				_face_to_position(target_pos)
				$Body/Hand.look_at(target.position)
			collosion = move_and_collide(velocity * speed * delta)
			position.x = clamp(position.x, -1080 * 2 , 1080*2) #temp
		HURT:
			collosion = move_and_collide(knockback(delta, knockback_direction))
			position.x = clamp(position.x, -1080 * 2 , 1080 * 2) #temp
		DEAD:
			pass


func hurt() -> void:
	if state == HURT:
		return
	state = HURT
	$KnockbackTimer.start()


func knockback(delta : float, direction : Vector2) -> Vector2:
	return knockback_speed * direction * delta


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
	new_bullet.speed = bullet_speed
	get_parent().add_child(new_bullet)


func _on_EnemyDetector_send_enemies(ens):
	enemies = ens

func check_target_state() -> void:
	for i in range(0,enemies.size() - 1):
		if enemies[i].get_dead():
			enemies.remove(i)

func _find_target() -> Area2D:
	var distance_array : Array
	for enemy in enemies:
		distance_array.append(abs(position.distance_to(enemy.position)))
	distance_array.sort()
	
	for enemy in enemies:
		if position.distance_to(enemy.position) == distance_array.front():
			if enemy.get_dead():
				distance_array.pop_front()
				var id = enemies.find(enemy)
				enemies.remove(id)
				return null
			else:
				return enemy
	return null

func _idle_fire():
	if not can_shoot:
		return
	print(target)
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
		$Body.scale.x = abs($Body.scale.x)
	else:
		$Body.scale.x = -abs($Body.scale.x)

func flame_fire_up() -> void:
	if velocity == Vector2():
		$Body/Hand/FireCore.emitting = true
	else:
		$Body/Hand/FireCore.emitting = false


func _on_ReloadTimer_timeout():
	reload = false


func _on_KnockbackTimer_timeout():
	state = MOVE


func _on_HurtBox_body_entered(body):
	if body is Enemy:
		if body.dead:
			return
	if body is Enemy or body is EnemyProjectile:
		knockback_direction = body.position.direction_to(position)
		hurt()


func _on_HurtBox_area_entered(area):
	if area is Enemy:
		if area.dead:
			return
	if area is Enemy or area is EnemyProjectile:
		knockback_direction = area.position.direction_to(position)
		hurt()


func _on_AttackRadius_body_entered(body):
	if body == target and not body.dead:
		can_shoot = true
		print(can_shoot)


func _on_AttackRadius_area_entered(area):
	if area == target and not area.dead:
		can_shoot = true
		print(can_shoot)
