extends Node

var fsm: StateMachine

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()

func enter() -> void:
	fsm.obj.character_status = CharacterStatus.DEAD

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
