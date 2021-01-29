extends Node

var fsm : PlayerStateMachine

enum {
	MOVING,
	IDLE
}

var enemies : Array
var detect_radius : float
var target : KinematicBody2D = null

var movement_state = IDLE

func enter() -> void:
	enemies = GlobalInstance.enemies
	detect_radius = fsm.player.character_stats.behaviour_stats.detect_radius

func physics_process(delta):
	enemies = GlobalInstance.enemies
	target = _find_target()
	if target != null:
		look_at_enemy(target.global_position)
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

	
	for enemy in enemies:
		if enemy.get_dead():
			enemies.erase(enemy)
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
	fsm.hand.rotation = (enemy_position.angle_to_point(fsm.hand.position)) - deg2rad(90)


func check_movement_state() -> void:
	match movement_state:
		MOVING:
			fsm.body.play("move")
			fsm.player.gun_move()
		IDLE:
			fsm.body.play("idle")
			fsm.player.gun_idle()
			
