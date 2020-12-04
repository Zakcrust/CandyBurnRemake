extends Enemy

enum {
	IDLE,
	MOVE,
	LOCK_CHARGE,
	CHARGE
	DEAD
}

## DEBUG ##
export (int) var custom_speed = 150
###########

signal death_sign()

var state = IDLE
var SPEED : int = 150
var charge_speed : int = 5 * SPEED
var charge_direction : Vector2
var paths : PoolVector2Array
var player : KinematicBody2D
var dead : bool  = false setget set_dead, get_dead
var health : int = 0 setget set_health, get_health
var attack : int = 0 setget set_attack, get_attack
var defense : int = 0 setget set_defense, get_defense

func _ready():
	character_stats = MobStats.new(4,1,0)
	health  = character_stats.health
	attack  = character_stats.attack
	defense = character_stats.defend
	SPEED = custom_speed
	charge_speed = SPEED * 5
	player = GlobalInstance.player
	start_pathfinding()

func start_pathfinding():
	if player != null and state != DEAD:
		$CheckPath.start()
		update_path()


func set_dead(value) -> void:
	dead = value

func get_dead() -> bool:
	return dead


func set_health(value : int) -> void:
	health = value
	check_health()

func get_health() -> int:
	return health

func set_attack(value : int) -> void:
	attack = value

func get_attack() -> int:
	return attack

func set_defense(value : int) -> void:
	defense = value

func get_defense() -> int:
	return defense

func get_type() -> CharacterType:
	return type

func _process(delta):
	match(state):
		IDLE:
			pass
		MOVE:
			action(delta)
		LOCK_CHARGE:
			pass
		CHARGE:
			charge(delta)
		DEAD:
			pass

func charge(delta):
	move_and_collide(charge_speed * charge_direction * delta)

func check_health() -> void:
	if health <= 0:
		health = 0
		state = DEAD
		dead = true
		$Sprite.play("dead")
		$CheckPath.stop()
		$ChargeCooldown.stop()
		$ChargeDelegate.stop()
		$ChargeTimer.stop()
		$Collider.call_deferred("set_disabled", true)
		emit_signal("death_sign")
		set_process(false)
	

func update_path() -> void:
	var path = get_tree().get_root().get_node("Main/Navigation2D").get_simple_path(global_position, player.global_position)
	if path != null:
		set_paths(path)

func set_paths(value : PoolVector2Array) -> void:
	paths = value
	paths.remove(0)
	set_process(true)
	state = MOVE
	$Sprite.play("move")


func move_along_path(distance : float) -> void:
	if state == DEAD:
		return
	var last_point : = position
	for index in range(paths.size()):
		var distance_to_next = last_point.distance_to(paths[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = last_point.linear_interpolate(paths[0], distance / distance_to_next)
			break
		elif paths.size() == 1 and distance >= distance_to_next:
			position = paths[0]
			if player != null:
				update_path()
			else:
				set_process(false)
			break

		distance -= distance_to_next
		last_point = paths[0]
		paths.remove(0)

func action(delta):
	var move_distance = SPEED * delta
	face_to(player.position)
	move_along_path(move_distance)


func face_to(pos : Vector2) -> void:
	if position.x < pos.x:
		$Sprite.scale.x = abs($Sprite.scale.x)
	else:
		$Sprite.scale.x = -abs($Sprite.scale.x)


func _on_CheckPath_timeout():
	update_path()


func _on_ChargeTimer_timeout():
	$Sprite.play("after_charge")
	set_process(false)
	$ChargeCooldown.start()
	


func _on_AttackRadius_body_entered(body):
	if body is Player and state != CHARGE and state != DEAD:
		state = LOCK_CHARGE
		$Sprite.play("before_charge")
		$ChargeDelegate.start()
		$CheckPath.stop()


func _on_ChargeDelegate_timeout():
	state = CHARGE
	$Sprite.play("charge")
	charge_direction = position.direction_to(player.global_position)
	$ChargeTimer.start()


func _on_ChargeCooldown_timeout():
	state = MOVE
	$Sprite.play("move")
	$CheckPath.start()


func hurt() -> void:
	$Sounds.play_sfx()
