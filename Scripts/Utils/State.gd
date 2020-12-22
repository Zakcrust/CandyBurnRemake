extends Node2D

class_name State

var fsm: StateMachine

func next(next_state):
	get_tree()
	fsm.change_to(next_state)

func exit():
	fsm.back()
