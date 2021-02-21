extends Node

var fsm : PlayerStateMachine

enum {
	MOVING,
	IDLE,
	MOVE_AND_SHOOT
}


var shooting : bool = false

var detect_radius : float
var target : KinematicBody2D = null

var movement_state = IDLE
var on_range : bool = false


func enter() -> void:
	detect_radius = fsm.player.character_stats.behaviour_stats.detect_radius
	fsm.player.current_status = CharacterStatus.ALIVE

func physics_process(delta):
	target = _find_target()
	fsm.player.target = target
	if target != null and target.current_status != CharacterStatus.DEAD:
		if fsm.player.global_position.distance_to(target.global_position) <= fsm.player.current_behaviour.detect_radius:
			look_at_enemy(target.global_position)
			face_to_enemy(target.global_position)
			if fsm.player.global_position.distance_to(target.global_position) <= fsm.player.current_behaviour.attack_radius:
				on_range = true
				shooting = true
				fsm.player.shoot()
			else:
				shooting = false
				on_range = false
				fsm.player.gun_idle()
	else:
		fsm.player.gun_idle()
		face_to(fsm.player.move_direction)
	_move(delta)
	set_movement_state()
	check_movement_state()

func set_movement_state() -> void:
	if fsm.player.move_direction == Vector2.ZERO:
		movement_state = IDLE
	else:
		movement_state = MOVING
		


func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()

func _move(delta) -> void:
	fsm.player.move_and_slide(fsm.player.move_direction * fsm.player.character_stats.speed)

func _find_target() -> KinematicBody2D:
	var closest_distance : float = -1
	var closest_target : KinematicBody2D = null
	var enemy_distance : float
	
	for enemy in fsm.player.enemies:
		if enemy == null:
			continue
		if enemy.current_status == CharacterStatus.DEAD:
			GlobalInstance.remove_enemy(enemy)
			continue
		enemy_distance = fsm.player.global_position.distance_to(enemy.global_position)
		if closest_distance < 0:
			closest_distance = enemy_distance
			closest_target = enemy
		elif enemy_distance < closest_distance:
			closest_distance = enemy_distance 
			closest_target = enemy
	
	if closest_target != null:
		if fsm.player.position.distance_to(closest_target.global_position) < detect_radius:
			return closest_target
	return null

func look_at_enemy(enemy_position : Vector2) -> void:
	fsm.hand.look_at(enemy_position)
#	fsm.hand.rotation_degrees -= 90
#	fsm.hand.rotation = (enemy_position.angle_to_point(fsm.hand.global_position))
#	print(fsm.hand.rotation_degrees)
#	if fsm.body.scale.x < 0:
#		if enemy_position.y > fsm.player.global_position.y:
#			if fsm.hand.rotation_degrees > -120:
#				fsm.hand.rotation -= deg2rad(45)
#			elif fsm.hand.rotation_degrees < 120:
#				fsm.hand.rotation += deg2rad(45)

func face_to_enemy(enemy_position : Vector2) -> void:
	if enemy_position.x < fsm.player.global_position.x:
		fsm.body.scale.x = -abs(fsm.body.scale.x)
	else:
		fsm.body.scale.x = abs(fsm.body.scale.x)

func face_to(direction : Vector2) -> void:
	if direction.x < 0:
		fsm.body.scale.x = -abs(fsm.body.scale.x)
	else:
		fsm.body.scale.x = abs(fsm.body.scale.x)

func check_movement_state() -> void:
	match movement_state:
		MOVING:
			fsm.body.play("move")
			if shooting:
				fsm.player.shoot()
			else:
				fsm.player.gun_move()
		IDLE:
			fsm.body.play("idle")
			if shooting:
				fsm.player.shoot()
			else:
				fsm.player.gun_idle()
