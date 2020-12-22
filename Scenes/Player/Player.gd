extends KinematicBody2D

class_name Player

var character_type : CharacterType = PlayerCharacter.new() setget , get_character_type
var player_stats : Stats = PlayerStats.new(5,5,100) setget set_player_stats, get_player_stats # (health_point, armour_point) 
var player_kine_stats : PlayerKinematicStats = PlayerKinematicStats.new(1024, 400) #(detect_radius, speed)

##### DEBUG #####
export (int) var custom_speed = 400
export (int) var bullet_speed = 300
#################

signal lose()
signal set_energy_max_ui(value)
signal set_energy_bar_ui(value)
signal set_coin_ui(value)

var health : float = player_stats.health setget set_health, get_health
var armour : float = player_stats.armour
var energy : float = 0 setget set_energy, get_energy
var detect_radius : float = player_kine_stats.detect_radius
var attack_radius : float = 0.7 * detect_radius
var speed : int = player_kine_stats.speed
var knockback_speed : float = speed * 5
var velocity : Vector2
var knockback_direction : Vector2
var bullet : PackedScene = load("res://Scenes/Projectile/Bullet.tscn")
var enemies : Array
var target : KinematicBody2D = null
var reload : bool = false
var collosion 


func set_health(value) -> void:
	print("health set")
	health = value
	if health > player_stats.health:
		health = player_stats.health
	$HealthDisplay.update_health_bar(player_stats.health, health)

func get_health() -> float:
	return health

func set_energy(value : float) -> void:
	energy = value
	if energy > 100:
		energy = 100
	elif energy < 0:
		energy = 0
		$Body/Hand/FireCore.stop_flame()
	emit_signal("set_energy_bar_ui", energy)

func get_energy() -> float:
	return energy

var pistol_asset = load("res://Assets/Main Character/Flamepistol/Flamepistol.tres")
var pistol_pos : Vector2 = Vector2(7, 58)

var flame_thrower_asset = load("res://Assets/Main Character/FlameThrower/Flamethrower.tres")
var flame_thrower_pos : Vector2 = Vector2(22, 100)

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

### COLLECTIBLES | HARUS DIPINDAH CODENYA | TEMPORARY
var coin : int = 0 setget set_coin, get_coin

func set_coin(value : int) -> void:
	coin = value
	emit_signal("set_coin_ui", coin)

func get_coin() -> int:
	return coin


#####################################################


func _ready():
	speed = custom_speed
	knockback_speed = speed * 3
	check_state_to_asset()
	GlobalInstance.player = self
	enemies = GlobalInstance.enemies
	emit_signal("set_energy_max_ui", player_stats.energy)

func check_state_to_asset() -> void:
	match(weapon_state):
		FLAME_PISTOL:
			$Body/Hand/Weapon.texture = pistol_asset
			$Body/Hand/Weapon.position = pistol_pos
		FLAMETHROWER:
			$Body/Hand/Weapon.texture = flame_thrower_asset
			$Body/Hand/Weapon.position = flame_thrower_pos


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
		_move_by_keyboard()
		_move_by_controller(delta)
		target = _find_target()
		_idle_fire()

func _look_at_mouse() -> void:
	look_at(get_global_mouse_position())


func _move_by_keyboard():
	velocity = Vector2()
	if Input.is_action_pressed("move_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		velocity += Vector2.RIGHT
	if Input.is_action_pressed("move_up"):
		velocity += Vector2.UP
	if Input.is_action_pressed("move_down"):
		velocity += Vector2.DOWN
	velocity = velocity.normalized()
	

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
				$Body/Hand.rotation_degrees -= 90
			collosion = move_and_slide(velocity * speed)
			position.x = clamp(position.x, -1080 , 2160) #temp
		HURT:
			collosion = null
			if collosion == null or not collosion is KinematicBody2D:
				collosion = move_and_collide(knockback(delta, knockback_direction))
			position.x = clamp(position.x, -1080 , 2160) #temp
		DEAD:
			pass


func hurt() -> void:
	$Sounds.play_sfx()
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
		$HurtBox.monitoring = false
		return
	state = HURT
	$KnockbackTimer.start()


func knockback(delta : float, direction : Vector2) -> Vector2:
	return knockback_speed * direction * delta


func _face_to_position(point : Vector2) -> void:
	if point.x >= 0:
		_flip_body(true)
	else:
		_flip_body(false)
		
		
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
	
	if closest_target != null:
		if position.distance_to(closest_target.global_position) < detect_radius:
			return closest_target
	return null

func _idle_fire():
	if target != null:
		if position.distance_to(target.position) > attack_radius:
			return
	match(weapon_state):
		FLAME_PISTOL:
			_fire_pistol()
		FLAMETHROWER:
			pass
	

func _fire_pistol() -> void:
	if velocity == Vector2() and not reload:
		if target != null:
			$ShootSound.play_sfx()
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
	$Body/Hand/FireCore.start_flame()



func _on_ReloadTimer_timeout():
	reload = false


func _on_KnockbackTimer_timeout():
	state = MOVE
	$HurtBox.monitoring = true


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
	if area.get_parent() is Enemy:
		if area.get_parent().dead:
			return
	if area is Enemy or area is EnemyProjectile:
		knockback_direction = area.position.direction_to(position)
		hurt()
		area.queue_free()

func refresh_enemy_pool():
	enemies = GlobalInstance.enemies


func _on_Control_end_flame_thrower():
	$Body/Hand/FireCore.stop_flame()
	weapon_state = FLAME_PISTOL
	check_state_to_asset()


func _on_Control_send_button_pos(pos):
	velocity = pos


func _on_Control_send_shoot():
	weapon_state = FLAMETHROWER
	check_state_to_asset()
	flame_fire_up()
