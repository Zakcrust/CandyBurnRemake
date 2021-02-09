extends Node

var fsm: StateMachine

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()


func enter() -> void:
	print("Current state : %s" % self.name)
	stun()
	yield(get_tree().create_timer(3.0), "timeout")
	exit()

func stun():
	print("Stunned")

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
