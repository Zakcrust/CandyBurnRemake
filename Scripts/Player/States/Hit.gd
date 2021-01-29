extends Node

var fsm : PlayerStateMachine

var velocity

func enter() -> void:
	yield(get_tree().create_timer(fsm.player.knockback_duration), "timeout")
	next("Move")

func physics_process(delta):
	_knockback(delta)

func _knockback(delta) -> void:
	velocity = fsm.player.move_and_collide(fsm.player.knockback_speed * fsm.player.knockback_direction * delta)

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()
