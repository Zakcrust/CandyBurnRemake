extends Node

var fsm: PlayerStateMachine

func enter() -> void:
	pass

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()
