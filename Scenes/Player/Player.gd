extends KinematicBody2D

class_name Player

var character_type : CharacterType = PlayerCharacter.new() setget , get_character_type
var player_stats : Stats = PlayerStats.new(5,5) setget set_player_stats, get_player_stats # (health_point, armour_point) 
var player_kine_stats : PlayerKinematicStats = PlayerKinematicStats.new(256, 400) #(detect_radius, speed)

##### DEBUG #####
export (int) var custom_speed = 400
export (int) var bullet_speed = 300
#################

signal lose()

var health : float = player_stats.health
var armour : float = player_stats.armour
var detect_radius : float = player_kine_stats.detect_radius
var speed : int = player_kine_stats.speed
var knockback_speed : float = speed * 10
var velocity : Vector2
var knockback_direction : Vector2
var bullet : PackedScene = load("res://Scenes/Projectile/Bullet.tscn")
var enemies : Array
var target : KinematicBody2D = null
var reload : bool = false
var collosion 


enum {
	FLAME_PISTOL,
	FLAMETHROWER,
	MOVE,
	HURT,
	DEAD
}

var can_shoot : bool  = true
var state = MOVE


var weapon_state = FLAME_PISTOL



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
	if state != DEAD:
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
				$Body/Hand.look_at(target.global_position)
			collosion = move_and_collide(velocity * speed * delta)
			position.x = clamp(position.x, -1080 , 2160) #temp
		HURT:
			collosion = null
			if collosion == null or not collosion is KinematicBody2D:
				collosion = move_and_collide(knockback(delta, knockback_direction))
			position.x = clamp(position.x, -1080 , 2160) #temp
		DEAD:
			pass


func hurt() -> void:
	health -= 1
	velocity = Vector2()
	$HealthDisplay.update_health_bar(player_stats.health, health)
	if health <= 0 :
		state = DEAD
		$Body.play("dead")
		$Body/Hand.hide()
		$Collider.call_deferred("set_disabled", true)
		emit_signal("lose")
		get_tree().paused = true
		return
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
	weapon_state = FLAMETHROWER


func _on_EnemyDetector_send_enemies(ens):
	enemies = ens
	print(enemies)

func check_target_state() -> void:
	for enemy in enemies:
		if enemy.get_dead():
			enemies.erase(enemy)

func _find_target() -> KinematicBody2D:
	var closest_distance : float = -1
	var closest_target : KinematicBody2D = null
	var enemy_distance : float

	
	for enemy in enemies:
		if enemy.get_dead():
			enemies.erase(enemy)
			continue
		enemy_distance = position.distance_to(enemy.global_position)
		if closest_distance < 0:
			closest_distance = enemy_distance
			closest_target = enemy
		elif enemy_distance < closest_distance:
			closest_distance = enemy_distance 
			closest_target = enemy
	
			
	return closest_target

func _idle_fire():
	if not can_shoot:
		return
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
#	if velocity == Vector2():
	if target != null:
		$Body/Hand/FireCore.start_flame()
	else:
		$Body/Hand/FireCore.stop_flame()
#	else:
#		$Body/Hand/FireCore.stop_flame()


func _on_ReloadTimer_timeout():
	reload = false


func _on_KnockbackTimer_timeout():
	state = MOVE


func _on_HurtBox_body_entered(body):
	if body is Enemy:
		if body.dead:
			return
		knockback_direction = body.position.direction_to(position)
		hurt()
	if body is EnemyProjectile:
		knockback_direction = body.position.direction_to(position)
		hurt()


func _on_HurtBox_area_entered(area):
	var hitbox_parent = area.get_parent()
	print(hitbox_parent)
	if area.get_parent() is Enemy:
		if area.get_parent().dead:
			return
	if area is Enemy or area is EnemyProjectile:
		knockback_direction = area.position.direction_to(position)
		hurt()


func _on_AttackRadius_body_entered(body):
	if body == target and not body.dead:
		can_shoot = true


func _on_AttackRadius_area_entered(area):
	if area == target and not area.dead:
		can_shoot = true


func _on_Control_end_flame_thrower():
	$Body/Hand/FireCore.stop_flame()
	weapon_state = FLAME_PISTOL
