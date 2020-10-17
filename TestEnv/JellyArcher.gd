extends Enemy

enum {
	IDLE,
	MOVE,
	DEAD,
	ATTACK
}


##### FOR TESTING PURPOSE #####################################################
export (int) var DEFAULT_SPEED = 200
export(float) var BULLET_SPEED = 200
###############################################################################


var state = IDLE
var SPEED : int = 200
var paths : PoolVector2Array
var player : RigidBody2D
var bolt : PackedScene = load("res://TestEnv/Bolt.tscn")
var dead : bool = false setget set_dead, get_dead
var health : int = 0 setget set_health, get_health
var attack : int = 0 setget set_attack, get_attack
var defense : int = 0 setget set_defense, get_defense

var can_fire : bool = false

func _ready():
	health  = character_stats.health
	attack  = character_stats.attack
	defense = character_stats.defend
	SPEED = DEFAULT_SPEED


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
		DEAD:
			pass
		ATTACK:
			attack_mode()

func attack_mode() -> void:
	face_to(player.position)
	$Sprite/Hand.look_at(player.position)

func fire() -> void:
	var new_bolt = bolt.instance()
	new_bolt.transform = $Sprite/Hand.global_transform
	new_bolt.position = $Sprite/Hand/GunPoint.global_position
	#####DEBUG######
	new_bolt.speed = BULLET_SPEED
	################
	get_parent().call_deferred("add_child", new_bolt)


func check_health() -> void:
	if health < 0:
		health = 0
		state = DEAD
		dead = true
		$Sprite.play("dead")
		$DetectRadius.monitoring = false
		$ViewRadius.monitoring = false
		$AttackRadius.monitoring = false
		$CheckPath.stop()
		set_process(false)
	

func update_path() -> void:
	var path = get_tree().get_root().get_node("TestMain/Navigation2D").get_simple_path(global_position, player.global_position)
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
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1

func _on_DetectRadius_body_entered(body):
	if body is Player and state != DEAD:
			player = body
			$CheckPath.start()
			update_path()


func _on_ViewRadius_body_exited(body):
	if body is Player and state != DEAD:
		if player == body:
			player == null
			set_process(false)
			state = IDLE
			$Sprite.play("idle")


func _on_CheckPath_timeout():
	update_path()


func _on_AttackRadius_body_entered(body):
	if body is Player:
		state = ATTACK
		$Sprite.play("attack")
		can_fire = true
		attack_mode()
		fire()
		$CheckPath.stop()
		$ReloadTimer.start()


func _on_ReloadTimer_timeout():
	if can_fire:
		fire()
	else:
		state = MOVE
		$CheckPath.start()
		$ReloadTimer.stop()


func _on_AttackRadius_body_exited(body):
	pass
